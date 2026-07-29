import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chatex/core/utils/toast_message.dart';
import 'package:chatex/core/local_storage/preferences.dart';
import 'dart:developer';
import 'package:chatex/l10n/app_localizations.dart';
import 'package:chatex/features/settings/data/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:chatex/core/utils/locale_provider.dart';
import 'package:chatex/core/constants/language_constants.dart';

//LanguageSetting OSZTÁLY ELEJE -------------------------------------------------------------------
class LanguageSetting extends StatefulWidget {
  const LanguageSetting({super.key});

  @override
  State<LanguageSetting> createState() => _LanguageSettingState();
}

class _LanguageSettingState extends State<LanguageSetting> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  //azért szükséges mert megjelenítünk egy pipát amelyik éppen ki van választva
  String _selectedLanguage = Preferences.getPreferredLanguage();

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  Future<void> _saveLanguage(BuildContext context, String language) async {
    await Preferences.setPreferredLanguage(language);
    final l10n = AppLocalizations.of(context)!;

    try {
      //TODO: átváltja a nyelvet, de azon marad csak a dart oldalon kell
      await SettingsService().updateLanguage(Preferences.getUserId()!, language);

      _selectedLanguage = language;

      if (context.mounted) {
        // 1. LÉPÉS: Lekérjük az új nyelv kódját (pl. 'hu' vagy 'en')
        final newLocaleCode = languageToLocale[language] ?? 'hu';

        // 2. LÉPÉS: Szólunk a Providernek (ami a main.dart-ban ül), hogy frissítse az egész appot!
        Provider.of<LocaleProvider>(context, listen: false).setLocale(Locale(newLocaleCode));

        ToastMessages.showToastMessages(
          l10n.updateLanguageSuccesful,
          0.2,
          Colors.green,
          Icons.check_rounded,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      }

      // else {
      //   if (context.mounted) {
      //     final l10n = AppLocalizations.of(context)!;
      //     ToastMessages.showToastMessages(
      //       l10n.errorUpdatingLanguage,
      //       0.2,
      //       Colors.redAccent,
      //       Icons.error_rounded,
      //       Colors.black,
      //       const Duration(seconds: 3),
      //       context,
      //     );
      //   }
      // }
    } catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ToastMessages.showToastMessages(
          l10n.connectionErrorUpdatingLanguage,
          0.2,
          Colors.redAccent,
          Icons.error_rounded,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      }
      log("Kapcsolati hiba a nyelv frissítésekor! ${e.toString()}");
    }

    if (context.mounted) {
      //Visszaadjuk a választott nyelvet
      Navigator.pop(context, language);
    }
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(),
        backgroundColor: Colors.grey[850],
        body: ListView(
          //tekerhető, mert a jövőben lehet annyi hogy nem fér ki
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          children: [
            _buildLanguageOption(context, "Magyar", "assets/flags/hungary.svg"),
            _buildLanguageOption(context, "English", "assets/flags/uk.svg"),
          ],
        ),
      ),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  PreferredSizeWidget _buildAppbar() {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(
        l10n.languages,
      ),
      backgroundColor: Colors.black,
      foregroundColor: Colors.deepPurpleAccent,
      shadowColor: Colors.deepPurpleAccent,
      elevation: 10,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String language, String flagPath) {
    //megjeleníti a választható nyelveket
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: ListTile(
        leading: SvgPicture.asset(
          flagPath,
          width: 60,
          height: 60,
        ),
        title: Text(
          language,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: _selectedLanguage == language
            ? const Icon(
                Icons.check,
                color: Colors.green,
              )
            : null,
        onTap: () async {
          //koppintásra elmenti a változtatást, és onnantól azon a nyelven lesz az alkalmazás
          await _saveLanguage(context, language);
        },
      ),
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//LanguageSetting OSZTÁLY VÉGE --------------------------------------------------------------------
