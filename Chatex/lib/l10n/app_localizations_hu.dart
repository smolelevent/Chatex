// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get languages => 'Nyelvek';

  @override
  String get language => 'Nyelv';

  @override
  String get emailAddressInvalid => 'Érvénytelen email cím!';

  @override
  String get emailAddress => 'E-mail cím';

  @override
  String get passwordTooShort => 'A jelszó túl rövid! (min 8 karakter)';

  @override
  String get passwordTooLong => 'A jelszó túl hosszú! (max 20 karakter)';

  @override
  String get passwordNeedsUppercase =>
      'A jelszónak legalább 1 nagybetűt tartalmaznia kell!';

  @override
  String get passwordNeedsLowercase =>
      'A jelszónak legalább 1 kisbetűt tartalmaznia kell!';

  @override
  String get passwordNeedsNumber =>
      'A jelszónak legalább 1 számot tartalmaznia kell!';

  @override
  String get login => 'Bejelentkezés';

  @override
  String get forgotPassword => 'Elfelejtett jelszó';

  @override
  String get createNewAccount => 'Új fiók létrehozása';

  @override
  String get resetPassword => 'Elfelejtett Jelszó';

  @override
  String get resetPasswordButton => 'Jelszó helyreállítás';

  @override
  String get resetPasswordInformation =>
      'A jelszó helyreállításához\nadja meg az e-mail címét!';

  @override
  String get registration => 'Regisztráció';

  @override
  String get usernameTooShort => 'A felhasználónév túl rövid! (min 3)';

  @override
  String get usernameTooLong => 'A felhasználónév túl hosszú! (max 20)';

  @override
  String get username => 'Felhasználónév';

  @override
  String get emailAddressHelp => 'pl: valaki@kiszolgalo.hu';

  @override
  String get passwordRequirements =>
      'Min. 8 karakter, Max. 20 karakter,\n1 kisbetű, 1 nagybetű, és 1 szám.';

  @override
  String get passwordsDoesntMatch => 'A jelszavak nem egyeznek meg!';

  @override
  String get confirmPassword => 'Jelszó újra';

  @override
  String get registrationButton => 'Regisztrálás';

  @override
  String get successfulRegistration => 'Sikeres regisztráció!';

  @override
  String get emailAddressAlreadyUsed =>
      'Ezzel az email címmel már létezik felhasználó!';

  @override
  String get connectionErrorRegistration =>
      'Kapcsolati hiba a\nregisztráció közben!';

  @override
  String get successfulLogin => 'Sikeres bejelentkezés!';

  @override
  String get loginCredentialsError => 'Hibás email cím vagy jelszó!';

  @override
  String get errorCode => 'Hiba kód:';

  @override
  String get connectionErrorLogin => 'Kapcsolati hiba a\nbejelentkezés közben!';

  @override
  String get connectionErrorLogout =>
      'Kapcsolati hiba a\nkijelentkezés közben!';

  @override
  String get resetPasswordEmailSent => 'Jelszó helyreállító email kiküldve!';

  @override
  String get noUserWithThisEmailAddress =>
      'Nincs ilyen email című felhasználó!';

  @override
  String get connectionErrorResetPassword =>
      'Kapcsolati hiba a\njelszó helyreállításánál!';

  @override
  String connectionError(String action) {
    return 'Kapcsolati hiba: $action!';
  }

  @override
  String permissionRequired(String typeOfPermission) {
    return 'A $typeOfPermission használatához\nengedély szükséges!';
  }

  @override
  String permissionDenied(String typeOfPermission) {
    return 'A(z) $typeOfPermission engedély tiltva van!\nÁtírányítás a beállításokba...';
  }

  @override
  String get notifications => 'értesítések';

  @override
  String get download => 'letöltés';

  @override
  String get groups => 'Csoportok';

  @override
  String get createGroupsTitle => 'Csoportok létrehozása';

  @override
  String get settings => 'Beállítások';

  @override
  String get createNewChat => 'Új chat készítése';

  @override
  String get createNewGroup => 'Új csoport készítése';

  @override
  String get connectionErrorLoadMessages =>
      'Kapcsolati hiba az üzenetek betöltésénél!';

  @override
  String get selectFiles => 'Fájl(ok) kiválasztása';

  @override
  String get connectionErrorSettingRead =>
      'Kapcsolati hiba\naz olvasottság átállításánál!';

  @override
  String get connectionErrorMessageDelete =>
      'Kapcsolati hiba\naz üzenet törlésénél!';

  @override
  String get justNow => 'Épp most';

  @override
  String minutesAgo(int minutes) {
    return '$minutes perce';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours órája';
  }

  @override
  String get yesterday => 'Tegnap';

  @override
  String get dayBefore => 'Tegnap előtt';

  @override
  String get errorTitle => 'Hiba';

  @override
  String get error => 'Hiba!';

  @override
  String get cancel => 'Mégse';

  @override
  String get delete => 'Törlés';

  @override
  String get areYouSureDeleteMessage =>
      'Biztosan törölni szeretnéd ezt az üzenetet?';

  @override
  String lastSeen(String formatLastSeen) {
    return 'Utoljára elérhető: $formatLastSeen';
  }

  @override
  String get online => 'online';

  @override
  String get userInformation => 'Információ a felhasználóról';

  @override
  String get chatEmpty => 'Ez a beszélgetés még üres.';

  @override
  String get scrollToBottom => 'Ugrás az aljára';

  @override
  String get startWriting => 'Kezdj el írni...';

  @override
  String get sendMessage => 'Üzenet küldése';

  @override
  String get emojiButton => 'Emoji gomb';

  @override
  String get couldntLoadChatList => 'Nem sikerült betölteni a chat listát!';

  @override
  String get connectionErrorGetChats => 'Kapcsolati hiba a chatek lekérésénél!';

  @override
  String get noChats => 'Még nincs egyetlen csevegésed sem.\nKezdj el egyet a ';

  @override
  String get iconEndOfSentence => ' ikonra kattintva!';

  @override
  String get you => 'Te: ';

  @override
  String get fileAttached => '📎 Fájl csatolva';

  @override
  String get imageSent => '🖼️ Kép küldve';

  @override
  String get noMessageYet => 'Nincs még üzenet';

  @override
  String get couldntLoadFriends => 'Nem sikerült betölteni a barátaid!';

  @override
  String get updateLanguageSuccesful => 'A nyelv sikeresen frissítve!';

  @override
  String get connectionErrorGettingFriendList =>
      'Kapcsolati hiba a\nbarátlista lekérésénél!';

  @override
  String get connectionErrorLoadingFriends =>
      'Kapcsolati hiba a\nbarátok betöltésekor!';

  @override
  String get chatCreated => 'Chat létrehozva!';

  @override
  String get connectionErrorStartingChat =>
      'Kapcsolati hiba a\nchat kezdeményezésénél!';

  @override
  String get startChat => 'Chat kezdése';

  @override
  String get searchFriends => 'Ismerősök keresése...';

  @override
  String get noResultsFound => 'Nincs találat';

  @override
  String get chatDeletedSuccesfully => 'A beszélgetés sikeresen törölve lett!';

  @override
  String get userOutputDelete => 'Hiba történt a törlés során!';

  @override
  String get connectionErrorDeletingChat =>
      'Kapcsolati hiba a\nchat törlése közben!';

  @override
  String get chatInformation => 'Chat információi';

  @override
  String get deleteChat => 'Chat törlése';

  @override
  String get areYouSureDeleteChat => 'Biztosan törlöd a chatet?';

  @override
  String get actionCannotUndone => 'Ez a művelet nem visszavonható!';

  @override
  String get seen => 'Látta';

  @override
  String get delivered => 'Kézbesítve';

  @override
  String get chats => 'Chatek';

  @override
  String get friends => 'Ismerősök';

  @override
  String get couldntLoadGroups => 'Nem sikerült betölteni a csoportjaidat!';

  @override
  String get connectionErrorGettingGroupList =>
      'Kapcsolati hiba a csoportok betöltésénél!';

  @override
  String get userNoGroupsFirstHalf =>
      'Még nem vagy tagja egyetlen csoportnak sem.\nCsinálj egyet a ';

  @override
  String get usersName => 'a felhasználók nevei';

  @override
  String get connectionErrorFriendRequestsNumber =>
      'Kapcsolati hiba a\nbarátkérések számának lekérésékor!';

  @override
  String get connectionErrorGettingUsers =>
      'Kapcsolati hiba a\nfelhasználók lekérésekor!';

  @override
  String get connectionErrorFriendRequestStatus =>
      'Kapcsolati hiba a\nbarátjelölés állapotának lekérésénél!';

  @override
  String get friendRequestSent => 'Barátjelölés elküldve!';

  @override
  String get errorOccurredFriendRequest => 'Hiba történt a barátjelölés során!';

  @override
  String get connectionErrorSendingFriendRequest =>
      'Kapcsolati hiba a barátküldés közben!';

  @override
  String get friendRequests => 'Barát jelölések';

  @override
  String get manageFriends => 'Barátok kezelése';

  @override
  String get enterUsername => 'Add meg a felhasználónevet!';

  @override
  String get friend => 'Barát';

  @override
  String get pending => 'Függőben';

  @override
  String get add => 'Jelölés';

  @override
  String get general => 'Általános';

  @override
  String get account => 'Fiók';

  @override
  String get manageAccount => 'Fiók kezelése';

  @override
  String get searchSettings => 'Beállítások keresése...';

  @override
  String get successfulChange => 'Sikeres változtatás!';

  @override
  String get unsuccessfulChange => 'A változtatás nem sikerült!';

  @override
  String get connectionErrorChangingStatus =>
      'Kapcsolati hiba a\nstátusz változtatásánál!';

  @override
  String get logout => 'Kijelentkezés';

  @override
  String get areYouSureLogout => 'Biztosan ki szeretnél jelentkezni?';

  @override
  String get yes => 'Igen';

  @override
  String get unknownMimeType => 'Ismeretlen MIME-típus a profilképnél!';

  @override
  String get offline => 'offline';

  @override
  String get status => 'Státusz';

  @override
  String get connectionErrorFriendRequests =>
      'Kapcsolati hiba a\nbarátkérések lekérésékor!';

  @override
  String get friendRequestAccepted => 'Barátkérés sikeresen elfogadva!';

  @override
  String get errorOccuredAccepting => 'Hiba történt az elfogadás során!';

  @override
  String get connectionErrorAcceptingFriendRequests =>
      'Kapcsolati hiba a\njelölés elfogadásakor!';

  @override
  String get friendRequestDeclined => 'Barátkérés elutasítva!';

  @override
  String get errorOccuredDeclining => 'Hiba történt az elutasítás során!';

  @override
  String get connectionErrorDecliningFriendRequests =>
      'Kapcsolati hiba a\njelölés elutasításakor!';

  @override
  String get noNewFriendRequest => 'Nincsenek új jelölések';

  @override
  String get errorWhileDecodingImage => 'Hiba a kép dekódolásakor!';

  @override
  String get friendRequest => 'Barát jelölés';

  @override
  String get friendRemoved => 'Barát törölve!';

  @override
  String get errorWhileDeletingFriend => 'Hiba a törlés közben';

  @override
  String get connectionErrorRemovingFriend =>
      'Kapcsolati hiba a\n barát törlése közben!';

  @override
  String get currentlyNoFriends => 'Jelenleg nincsenek barátaid!';

  @override
  String get currentFriends => 'Jelenlegi barátaid';

  @override
  String get removeFriend => 'Barát törlése';

  @override
  String get areYouSureRemoveFriend =>
      'Biztosan törölni szeretnéd ezt a barátot?';

  @override
  String updatedSuccessfully(String item) {
    return '$item sikeresen frissítve!';
  }

  @override
  String errorUpdating(String item) {
    return 'Hiba történt a(z) $item frissítésekor!';
  }

  @override
  String get errorUpdatingUsername =>
      'Hiba történt a felhasználónév frissítésekor!';

  @override
  String get remove => 'Eltávolítás';

  @override
  String get connectionErrorUpdatingUsername =>
      'Kapcsolati hiba a\nfelhasználónév módosítása közben!';

  @override
  String get errorUpdatingEmailAddress =>
      'Hiba történt az email cím frissítésekor!';

  @override
  String get connectionErrorUpdatingEmailAddress =>
      'Kapcsolati hiba az\nemail cím frissítése közben!';

  @override
  String get errorUpdatingPassword => 'Hiba a jelszó frissítése közben!';

  @override
  String get connectionErrorUpdatingPassword =>
      'Kapcsolati hiba a\njelszó frissítése közben!';

  @override
  String get emailAddressUpdated => 'Email cím frissítve!';

  @override
  String get usernameUpdated => 'Felhasználónév frissítve!';

  @override
  String get unsupportedFileFormat => 'Nem támogatott fájlformátum!';

  @override
  String get imageSelectedCanUpdate => 'Kép kiválasztva! Most módosíthatod!';

  @override
  String get errorSelectingImage => 'Hiba a kép kiválasztásánál!';

  @override
  String get passwordUpdated => 'Jelszó frissítve!';

  @override
  String get errorUpdatingProfilePicture =>
      'Hiba történt a profilkép frissítésekor!';

  @override
  String get connectionErrorUpdatingProfilePicture =>
      'Kapcsolati hiba a\nprofilkép frissítése közben!';

  @override
  String get changesSaved => 'Módosítások elmentve!';

  @override
  String get cantModifySameValue => 'Nem lehet ugyanarra módosítani!';

  @override
  String get profilePictureUpdatedSucessfully =>
      'Profilkép sikeresen feltöltve!';

  @override
  String get accountDeleted => 'Fiók törölve!';

  @override
  String get errorDeletingAccount => 'Hiba a fiók törlésénél!';

  @override
  String get connectionErrorDeletingAccount =>
      'Kapcsolati hiba a\nfiók törlése közben!';

  @override
  String get accountDetails => 'Fiók adatai';

  @override
  String get usernameCannotBeEmpty => 'A felhasználónév\nnem lehet üres!';

  @override
  String get emailAddressCannotBeEmpty => 'Az email cím\nnem lehet üres!';

  @override
  String get changePassword => 'Jelszó módosítása';

  @override
  String get profilePicture => 'Profilkép';

  @override
  String get fieldMustMatchPassword =>
      'A mezőnek meg kell egyeznie a jelszó mezővel!';

  @override
  String get saveChanges => 'Módosítások mentése';

  @override
  String get deleteAccount => 'Fiók törlése';

  @override
  String get areYouSureDeleteAccount => 'Biztosan törlöd a fiókodat?';

  @override
  String get password => 'Jelszó';

  @override
  String get accountManagement => 'Fiók kezelése';

  @override
  String get errorUpdatingLanguage => 'Hiba történt a nyelv frissítésekor!';

  @override
  String get connectionErrorUpdatingLanguage =>
      'Kapcsolati hiba a nyelv frissítésekor!';

  @override
  String get filesTooLargeTitle => 'A fájlok mérete túl nagy!';

  @override
  String get filesTooLargeContent =>
      'Csak 100 MB vagy alatti fájlokat lehet küldeni!';

  @override
  String get imagesTooLargeTitle => 'A képek mérete túl nagy!';

  @override
  String get imagesTooLargeContent =>
      'Csak 50 MB vagy alatti képeket lehet küldeni!';

  @override
  String get messageTooLongTitle => 'Túl hosszú üzenet!';

  @override
  String messageTooLongContent(int characters) {
    return 'Legfeljebb $characters karakter hosszú üzenetet lehet küldeni!';
  }

  @override
  String get back => 'Vissza';

  @override
  String get fileUpload => 'Fájl feltöltése';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galéria';

  @override
  String get downloadReady => 'Letöltés kész';

  @override
  String savedTo(String fileName, String path) {
    return '$fileName elmentve ide:\n$path';
  }

  @override
  String get fileDownloadError => 'Nem sikerült letölteni a file-t!';

  @override
  String get imageSaved => 'Kép elmentve';

  @override
  String get imageDownloadError => 'Nem sikerült letölteni a képet!';
}
