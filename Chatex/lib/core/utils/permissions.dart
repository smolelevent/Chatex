import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chatex/core/utils/toast_message.dart';
import 'package:chatex/l10n/app_localizations.dart';
import 'dart:developer';

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

//ez a Dart azért felel hogy a felhasználó minden funkcióhoz hozzáférhessen és használhassa,
//de ezekhez engedélyeket kell adni! (értesítések, letöltések) Így az engedélykérést látja el a permissions.dart

//EGYÉB METÓDUSOK ELEJE ---------------------------------------------------------------------------

Future<int> _getAndroidSdkVer() async {
  //ez felel a verzió lekéréséért!
  try {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    return deviceInfo.version.sdkInt;
  } catch (e) {
    log("Nem sikerült lekérni az Android SDK verziót: ${e.toString()}");
    return 0;
  }
}

//ha az engedély meg van tagadva, akkor az engedély típusát átadva toast üzenetet jelenítünk meg
void _showToastWhenDenied(BuildContext context, String typeOfPermission) {
  //háttérmetódusoknál mindig if(context.mounted) vizsgálat
  if (context.mounted) {
    final l10n = AppLocalizations.of(context)!;
    ToastMessages.showToastMessages(
      l10n.permissionRequired(typeOfPermission),
      0.3,
      Colors.redAccent,
      Icons.warning_rounded,
      Colors.black,
      const Duration(seconds: 3),
      context,
    );
  }
}

//ha az engedély le van tiltva, akkor is így járunk el csak más üzenettel
void _showToastWhenPermanentlyDenied(BuildContext context, String typeOfPermission) {
  if (context.mounted) {
    final l10n = AppLocalizations.of(context)!;
    ToastMessages.showToastMessages(
      //TODO: változót megadni
      l10n.permissionDenied(typeOfPermission),
      0.3,
      Colors.redAccent,
      Icons.warning_rounded,
      Colors.black,
      const Duration(seconds: 3),
      context,
    );
  }
}

//EGYÉB METÓDUSOK VÉGE ----------------------------------------------------------------------------

//ENGEDÉLYT KÉRŐ METÓDUSOK ELEJE ------------------------------------------------------------------

//értesítésekhez szükséges engedély (Android 13+)
Future<void> requestNotificationPermission(BuildContext context) async {
  //ez a metódus engedélyt kér az értesítések fogadásához
  final notificationPermissionStatus = await Permission.notification.status;

  if (notificationPermissionStatus.isPermanentlyDenied) {
    //ha a telefon beállításaiban már le van tíltva a Chatex értesítés küldése akkor ez történik:
    if (context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      _showToastWhenPermanentlyDenied(context, l10n.notifications);
      await Future.delayed(const Duration(seconds: 4));
      openAppSettings(); //toast üzenet után nyissa meg az alkalmazás beállításait a telefonon
      return;
    }
  }

  //ha viszont nem történt ilyen akkor kérjen engedélyt
  final notificationUsageRequest = await Permission.notification.request();
  if (!notificationUsageRequest.isGranted) {
    if (context.mounted) {
      //ha az engedély lelett tiltva akkor ezt a választ adja vissza a felhasználónak
      final l10n = AppLocalizations.of(context)!;
      _showToastWhenDenied(context, l10n.notifications);
    }
  }
}

//letöltésekhez szükséges engedély
//(Android 10 és alatta, mivel Android 11-től már "Scoped Storage" néven kezelik a telefonok amihez nem kell engedélyt adni)
Future<void> requestDownloadPermission(BuildContext context) async {
  //lekérjük az android verziót device_info_plus csomaggal
  final androidVersion = await _getAndroidSdkVer();

  //ne csináljon semmit ha a legalább eléri a 30-as api-t
  if (androidVersion >= 30) {
    log("Scoped storage használata, nincs szükség engedélyre! (letöltés miatt)");
    return;
  }

  final storagePermissionStatus = await Permission.storage.status;
  if (storagePermissionStatus.isGranted) return;

  if (storagePermissionStatus.isPermanentlyDenied) {
    if (context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      _showToastWhenPermanentlyDenied(context, l10n.download);
      await Future.delayed(const Duration(seconds: 4));
      openAppSettings(); //ismét megnyitjuk a beállítását az alkalmazásnak
      return;
    }
  }
  if (context.mounted) {
    final l10n = AppLocalizations.of(context)!;
    //Első kérés előtt tájékoztatjuk a felhasználót,
    _showToastWhenDenied(context, l10n.download);
    await Future.delayed(const Duration(seconds: 4));

    //majd kérést indítunk!
    final storageUsageRequest = await Permission.storage.request();
    if (!storageUsageRequest.isGranted) {
      _showToastWhenDenied(context, l10n.download);
    }
  }
}

//ENGEDÉLYT KÉRŐ METÓDUSOK VÉGE -------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------
