import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:chatex/core/local_storage/preferences.dart';
import 'package:chatex/core/utils/toast_message.dart';
import 'package:chatex/core/constants/validation_constants.dart';
import 'dart:developer';
import 'dart:io';
import 'package:chatex/l10n/app_localizations.dart';
import 'package:chatex/features/auth/presentation/screens/login_screen.dart';
import 'package:chatex/features/settings/data/settings_service.dart';
import 'package:chatex/core/presentation/widgets/custom_avatar.dart';

//AccountSetting OSZTÁLY ELEJE --------------------------------------------------------------------
class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

//TODO: profilkép kiválasztásánál módosítós toast megjelent módosítottam is, de kiírta hogy hiba majd hogy sikerült és nem változott meg adatbázisba pedig semmi nincs
//TODO: email cím kiírja hiba történt majd hogy sikeres és semmi nem történik
//TODO: mi ez a lila toast geci

class _AccountSettingState extends State<AccountSetting> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  //a controllerekből lehet kivenni az input mezők értékeit
  //a FocusNode-ok az input mezők hint és label text közötti váltakozásáért fog felelni
  //amit társítani kell egy bool változóhoz ami a FocusNode .hasFocus értékét fogja tartalmazni, ez alapján változik a design

  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  bool _isUsernameFocused = false;

  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isEmailFocused = false;

  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordFocused = false;
  //a jelszó láthatásokat külön kezeljük, és ki-be kapcsolójuk van
  bool _isPasswordNotVisible = true;

  final TextEditingController _passwordConfirmController = TextEditingController();
  final FocusNode _passwordConfirmFocusNode = FocusNode();
  bool _isPasswordConfirmFocused = false;
  //külön
  bool _isPasswordConfirmNotVisible = true;

  //ezek felelnek azért, ha a felhasználó megnyomja a ceruza ikont akkor megjelenjen az input mező és ezeket külön kezeljük
  bool _isEditingUsername = false;
  bool _isEditingEmail = false;
  bool _isEditingPassword = false;

  //alapértelmezetten betöltjük a felhasználó jelenlegi profilképét
  String? _profilePicture = Preferences.getProfilePicture();
  File? _selectedImage;
  bool _isPickingImage = false;

  //a _formKey felel azért hogy kitudjuk venni a Form értékeit, míg a _isFormValid a gomb megnyomhatóságáért felel!
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isFormValid = false;

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _usernameFocusNode.addListener(() {
      setState(() {
        _isUsernameFocused = _usernameFocusNode.hasFocus;
      });
    });

    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });

    _passwordConfirmFocusNode.addListener(() {
      setState(() {
        _isPasswordConfirmFocused = _passwordConfirmFocusNode.hasFocus;
      });
    });

    //ha megjelenik egy input mező frissítsük a képernyőt
    _usernameController.addListener(() {
      if (_isEditingUsername) setState(() {});
    });

    _emailController.addListener(() {
      if (_isEditingEmail) setState(() {});
    });

    _passwordController.addListener(() {
      if (_isEditingPassword) setState(() {});
    });

    //mindegyik kontrollernél és focusNode-nál figyeljük hogy van e valid mező hogy a gomb megfelelően frissítsen
    _usernameController.addListener(_onAnyFieldValid);
    _emailController.addListener(_onAnyFieldValid);
    _passwordController.addListener(_onAnyFieldValid);
    _passwordConfirmController.addListener(_onAnyFieldValid);

    _usernameFocusNode.addListener(_onAnyFieldValid);
    _emailFocusNode.addListener(_onAnyFieldValid);
    _passwordFocusNode.addListener(_onAnyFieldValid);
    _passwordConfirmFocusNode.addListener(_onAnyFieldValid);
  }

  @override
  void dispose() {
    //ha már nincsen használatban akkor felszabadítja az erőforrásokat amit eddig foglaltak
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();

    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmFocusNode.dispose();
  }

  void _onAnyFieldValid() {
    //ez dönti el hogy engedélyezve legyen a mentés gomb vagy sem
    //minden input változásnál lefut
    final currentState = _formKey.currentState;
    if (currentState == null) return;

    currentState.save(); // Ez azért kell, hogy az értékeket is le tudjunk kérni

    final isUsernameValid = currentState.fields['username']?.validate() ?? false;
    final isEmailValid = currentState.fields['email']?.validate() ?? false;

    // Jelszónál dupla feltétel: csak akkor nézzük, ha a megerősítő jelszó is valid
    final isPasswordValid = (currentState.fields['password']?.validate() ?? false) && (currentState.fields['password_confirm']?.validate() ?? false);

    // Profilkép változás ha a kiválasztott kép nem üres
    final hasNewProfilePicture = _selectedImage != null;

    //bármelyik is igaz
    final atLeastOneValid = isUsernameValid || isEmailValid || isPasswordValid || hasNewProfilePicture;

    setState(() {
      //átadjuk a gombot engedélyező változónak
      _isFormValid = atLeastOneValid;
    });
  }

  Future<bool> _updateUsername(String newUsername) async {
    if (!mounted) return false;
    final l10n = AppLocalizations.of(context)!;
    try {
      await SettingsService().updateUsername(Preferences.getUserId()!, newUsername);
      await Preferences.setUsername(newUsername);

      if (mounted) {
        ToastMessages.showToastMessages(l10n.usernameUpdated, 0.2, Colors.green, Icons.check, Colors.black, const Duration(seconds: 2), context);
      }
      return true;
      //else { TODO: kell-e?
//         ToastMessages.showToastMessages(
//           l10n.errorUpdatingUsername,
//           0.2,
//           Colors.redAccent,
//           Icons.error_rounded,
//           Colors.black,
//           const Duration(seconds: 2),
//           context,
//         );
//       }
    } catch (e) {
      if (mounted) {
        ToastMessages.showToastMessages(
            l10n.errorUpdatingUsername, 0.2, Colors.redAccent, Icons.error_rounded, Colors.black, const Duration(seconds: 2), context);
      }
      log("Hiba a felhasználónév módosítása közben! $e");
      return false;
    }
  }

  Future<bool> _updateEmail(String newEmail) async {
    if (!mounted) return false;
    final l10n = AppLocalizations.of(context)!;
    try {
      await SettingsService().updateEmail(Preferences.getUserId()!, newEmail);
      await Preferences.setEmail(newEmail);

      if (mounted) {
        ToastMessages.showToastMessages(l10n.emailAddressUpdated, 0.2, Colors.green, Icons.check, Colors.black, const Duration(seconds: 3), context);
      }
      return true;
    } catch (e) {
      if (mounted) {
        ToastMessages.showToastMessages(
            l10n.errorUpdatingEmailAddress, 0.2, Colors.redAccent, Icons.error_rounded, Colors.black, const Duration(seconds: 3), context);
      }
      log("Hiba az email frissítése közben! $e");
      return false;
      //ToastMessages.showToastMessages(
      //         l10n.connectionErrorUpdatingEmailAddress,
      //         0.2,
      //         Colors.redAccent,
      //         Icons.error_rounded,
      //         Colors.black,
      //         const Duration(seconds: 3),
      //         context,
      //       );
    }
  }

  Future<bool> _updatePassword(String newPassword) async {
    if (!mounted) return true;
    final l10n = AppLocalizations.of(context)!;
    try {
      await SettingsService().updatePassword(newPassword);
      if (mounted) {
        ToastMessages.showToastMessages(
            l10n.passwordUpdated, 0.2, Colors.green, Icons.check_rounded, Colors.black, const Duration(seconds: 2), context);
      }
      return true;
    } catch (e) {
      if (mounted) {
        ToastMessages.showToastMessages(
            l10n.errorUpdatingPassword, 0.2, Colors.redAccent, Icons.error, Colors.black, const Duration(seconds: 2), context);
      }
      log("Hiba a jelszó frissítése közben! $e");
      return false;
      //       ToastMessages.showToastMessages(
      //         l10n.connectionErrorUpdatingPassword,
      //         0.2,
      //         Colors.redAccent,
      //         Icons.error_rounded,
      //         Colors.black,
      //         const Duration(seconds: 3),
      //         context,
      //       );
    }
  }

  Future<bool> _updateProfilePicture() async {
    if (_selectedImage == null || !mounted) return false;
    final l10n = AppLocalizations.of(context)!;
    try {
      final newUrl = await SettingsService().uploadProfilePicture(Preferences.getUserId()!, _selectedImage!);
      await Preferences.setProfilePicture(newUrl);

      if (mounted) {
        ToastMessages.showToastMessages(
            l10n.profilePictureUpdatedSucessfully, 0.2, Colors.green, Icons.check_rounded, Colors.black, const Duration(seconds: 2), context);
      }
      return true;
    } catch (e) {
      if (mounted) {
        ToastMessages.showToastMessages(
            l10n.errorUpdatingProfilePicture, 0.2, Colors.redAccent, Icons.error_rounded, Colors.black, const Duration(seconds: 2), context);
      }
      //       ToastMessages.showToastMessages(
      //         l10n.connectionErrorUpdatingProfilePicture,
      //         0.2,
      //         Colors.redAccent,
      //         Icons.error_rounded,
      //         Colors.black,
      //         const Duration(seconds: 3),
      //         context,
      //       );
      log("Hiba a profilkép frissítése közben! $e");
      return false;
    }
  }

  // --- KÉP KIVÁLASZTÁSA (BASE64 KUKA, TOAST KIEGÉSZÍTÉS) ---
  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    setState(() => _isPickingImage = true);

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        setState(() => _isPickingImage = false);
        return;
      }

      final filePath = pickedFile.path;
      final fileExtension = filePath.split('.').last.toLowerCase();
      //TODO: KIZÁRÓLAG EZT A HÁRMAT ENGEDJÜK (Nincs SVG)
      final supportedExtensions = ['png', 'jpg', 'jpeg'];

      if (!supportedExtensions.contains(fileExtension)) {
        ToastMessages.showToastMessages(
          "${l10n.unsupportedFileFormat} (PNG, JPG, JPEG)",
          0.2,
          Colors.red,
          Icons.image,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
        setState(() => _isPickingImage = false);
        return;
      }

      setState(() {
        _selectedImage = File(filePath);
        // Helyileg frissítjük a UI-t, hogy lássa az új képet (még mentés előtt)
        _profilePicture = filePath;
        _isPickingImage = false;
      });

      ToastMessages.showToastMessages(
          l10n.imageSelectedCanUpdate, 0.2, Colors.orange, Icons.image, Colors.black, const Duration(seconds: 2), context);
      _onAnyFieldValid();
    } catch (e) {
      setState(() => _isPickingImage = false);
      if (mounted) {
        ToastMessages.showToastMessages(
            l10n.errorSelectingImage, 0.2, Colors.redAccent, Icons.image, Colors.black, const Duration(seconds: 2), context);
      }
      log("Hiba kép kiválasztásánál: $e");
    }
  }

  // Future<void> _pickImage() async {
  //   if (_isPickingImage) return; // ha már fut, akkor kilépünk
  //
  //   setState(() {
  //     _isPickingImage = true;
  //   });
  //
  //   if (context.mounted) {
  //     final l10n = AppLocalizations.of(context)!;
  //     try {
  //       final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //       if (pickedFile == null) {
  //         setState(() {
  //           _isPickingImage = false;
  //         });
  //         return;
  //       }
  //
  //       final filePath = pickedFile.path;
  //       final fileExtension = filePath.split('.').last.toLowerCase();
  //       final supportedExtensions = ['svg', 'png', 'jpg', 'jpeg'];
  //
  //       if (!supportedExtensions.contains(fileExtension)) {
  //         //ha nem támogatott formátum lett kiválasztva
  //
  //         ToastMessages.showToastMessages(
  //           l10n.unsupportedFileFormat,
  //           0.2,
  //           Colors.red,
  //           Icons.image,
  //           Colors.black,
  //           const Duration(seconds: 2),
  //           context,
  //         );
  //
  //         setState(() {
  //           //engedjük hogy újra megnyissa a kép választót
  //           _isPickingImage = false;
  //         });
  //         return;
  //       }
  //
  //       final file = File(filePath);
  //       final bytes = await file.readAsBytes();
  //
  //       //base64-es kódolás amihez hozzátesszük a mimeType-ot
  //       final base64 = base64Encode(bytes);
  //
  //       String mimeType;
  //       switch (fileExtension) {
  //         case "svg":
  //           mimeType = "data:image/svg+xml;base64,";
  //           break;
  //         case "png":
  //           mimeType = "data:image/png;base64,";
  //           break;
  //         case "jpg":
  //           mimeType = "data:image/jpg;base64,";
  //           break;
  //         case "jpeg":
  //           mimeType = "data:image/jpeg;base64,";
  //           break;
  //         default:
  //           mimeType = "";
  //       }
  //
  //       setState(() {
  //         //frissítjük mind a kettő változót, és már az új profilkép fog megjelenni
  //         _selectedImage = file;
  //         _profilePicture = "$mimeType$base64";
  //         _isPickingImage = false; // itt is vissza állítjuk
  //       });
  //
  //       ToastMessages.showToastMessages(
  //         l10n.imageSelectedCanUpdate,
  //         0.2,
  //         Colors.orange,
  //         Icons.image,
  //         Colors.black,
  //         const Duration(seconds: 2),
  //         context,
  //       );
  //
  //       //frissítjük a mentés gombot
  //       _onAnyFieldValid();
  //
  //       //frissítsük a cache-t is
  //       _cacheProfileImage();
  //     } catch (e) {
  //       setState(() {
  //         _isPickingImage = false;
  //       });
  //
  //       ToastMessages.showToastMessages(
  //         l10n.errorSelectingImage,
  //         0.2,
  //         Colors.redAccent,
  //         Icons.image,
  //         Colors.black,
  //         const Duration(seconds: 2),
  //         context,
  //       );
  //       log("Hiba kép kiválasztásánál: ${e.toString()}");
  //     }
  //   }
  // }

  Future<void> _deleteAccount() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      await SettingsService().deleteAccount(Preferences.getUserId()!);
      await Preferences.clearPreferences();

      if (mounted) {
        ToastMessages.showToastMessages(
            l10n.accountDeleted, 0.3, Colors.green, Icons.check_rounded, Colors.black, const Duration(seconds: 2), context);
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginUI()), (route) => false);
        });
      }
    } catch (e) {
      if (mounted) {
        ToastMessages.showToastMessages(
            l10n.errorDeletingAccount, 0.3, Colors.redAccent, Icons.error_rounded, Colors.black, const Duration(seconds: 3), context);
      }
      log("Hiba a fiók törlése közben! $e");
    }
    //       ToastMessages.showToastMessages(
    //         l10n.connectionErrorDeletingAccount,
    //         0.2,
    //         Colors.redAccent,
    //         Icons.error_rounded,
    //         Colors.black,
    //         const Duration(seconds: 3),
    //         context,
    //       );
  }

  Future<void> _handleSave() async {
    FocusScope.of(context).unfocus();

    //eltároljuk az új értékekeket
    final newUsername = _formKey.currentState!.fields["username"]?.value?.trim() ?? '';
    final newEmail = _formKey.currentState!.fields["email"]?.value?.trim() ?? '';
    final newPassword = _formKey.currentState!.fields["password"]?.value?.trim() ?? '';

    final oldUsername = Preferences.getUsername();
    final oldEmail = Preferences.getEmail();

    bool somethingChanged = false;

    if (newUsername.isNotEmpty && newUsername != oldUsername && newUsername != null) {
      final bool success = await _updateUsername(newUsername);
      if (success) somethingChanged = true;
    }

    if (newEmail.isNotEmpty && newEmail != oldEmail && newEmail != null) {
      final bool success = await _updateEmail(newEmail);
      if (success) somethingChanged = true;
    }

    //TODO: jelszó frissítése (lehet ugyanarra változtatni a jelszót, de azt már nem tudtam megoldani hogy ne lehessen)
    if (newPassword.isNotEmpty && newPassword != null) {
      final bool success = await _updatePassword(newPassword);
      if (success) somethingChanged = true;
    }

    if (_selectedImage != null) {
      final bool success = await _updateProfilePicture();
      if (success) somethingChanged = true;
    }

    if (context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      if (somethingChanged) {
        ToastMessages.showToastMessages(
          l10n.changesSaved,
          0.2,
          Colors.deepPurpleAccent,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );

        setState(() {
          _isEditingUsername = false;
          _isEditingEmail = false;
          _isEditingPassword = false;

          _selectedImage = null;
          _isFormValid = false;
        });

        _formKey.currentState!.reset();
        _usernameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _passwordConfirmController.clear();
      } else {
        ToastMessages.showToastMessages(
          l10n.cantModifySameValue,
          0.2,
          Colors.redAccent,
          Icons.error_rounded,
          Colors.black,
          const Duration(seconds: 4),
          context,
        );
      }
    }
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: _buildAppbar(),
        body: _buildBody(),
      ),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  //TODO: profilkép méretező, támogatott fájlformátumok heic stb., design váltás
  //TODO: [log] Hiba az email frissítése közben! PostgrestException(message: new row violates row-level security policy for table "users", code: 42501, details: Forbidden, hint: null)
  PreferredSizeWidget _buildAppbar() {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      title: AutoSizeText(
        l10n.accountManagement,
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

  Widget _buildBody() {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      //scrollolhatóvá teszi a képernyőt, ha nem fér ki valami
      padding: const EdgeInsets.all(16),
      child: FormBuilder(
        key: _formKey,
        onChanged: _onAnyFieldValid,
        child: Column(
          children: [
            _buildDivider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    //ne érjen össze az input mező a profilképpel
                    padding: const EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        _buildEditableField(
                          title: l10n.username,
                          fieldName: "username",
                          initialValue: Preferences.getUsername(),
                          isEditing: _isEditingUsername,
                          focusNode: _usernameFocusNode,
                          focusVariable: _isUsernameFocused,
                          controller: _usernameController,
                          keyboardType: TextInputType.name,
                          onEditToggle: () {
                            setState(() {
                              _isEditingUsername = !_isEditingUsername;
                            });
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.minLength(
                              usernameMinLength,
                              errorText: l10n.passwordTooShort,
                              checkNullOrEmpty: false,
                            ),
                            FormBuilderValidators.maxLength(
                              usernameMaxLength,
                              errorText: l10n.passwordTooLong,
                              checkNullOrEmpty: false,
                            ),
                            FormBuilderValidators.required(errorText: l10n.usernameCannotBeEmpty, checkNullOrEmpty: true),
                          ]),
                        ),
                        _buildEditableField(
                          title: l10n.emailAddress,
                          fieldName: "email",
                          initialValue: Preferences.getEmail(),
                          isEditing: _isEditingEmail,
                          focusNode: _emailFocusNode,
                          focusVariable: _isEmailFocused,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          onEditToggle: () {
                            setState(() {
                              _isEditingEmail = !_isEditingEmail;
                            });
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.email(
                                regex: RegExp(emailValidationRegex, unicode: true), errorText: l10n.emailAddressInvalid, checkNullOrEmpty: false),
                            FormBuilderValidators.required(errorText: l10n.emailAddressCannotBeEmpty, checkNullOrEmpty: true),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildProfilePicture(),
              ],
            ),
            _buildEditableField(
              title: l10n.changePassword,
              fieldName: "password",
              initialValue: null,
              isEditing: _isEditingPassword,
              focusNode: _passwordFocusNode,
              focusVariable: _isPasswordFocused,
              controller: _passwordController,
              keyboardType: null,
              onEditToggle: () {
                setState(() {
                  _isEditingPassword = !_isEditingPassword;
                });
              },
              obscureText: _isPasswordNotVisible,
              onVisibilityToggle: () {
                setState(() {
                  _isPasswordNotVisible = !_isPasswordNotVisible;
                });
              },
              helperText: l10n.passwordRequirements,
              helperStyle: const TextStyle(
                color: Colors.white,
                letterSpacing: 1.0,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.minLength(passwordMinLength, errorText: l10n.passwordTooShort, checkNullOrEmpty: false),
                FormBuilderValidators.maxLength(passwordMaxLength, errorText: l10n.passwordTooLong, checkNullOrEmpty: false),
                FormBuilderValidators.hasUppercaseChars(
                    atLeast: 1, regex: RegExp(r'\p{Lu}', unicode: true), errorText: l10n.passwordNeedsUppercase, checkNullOrEmpty: false),
                FormBuilderValidators.hasLowercaseChars(
                    atLeast: 1, regex: RegExp(r'\p{Ll}', unicode: true), errorText: l10n.passwordNeedsLowercase, checkNullOrEmpty: false),
                FormBuilderValidators.hasNumericChars(
                    atLeast: 1, regex: RegExp(r'[0-9]', unicode: true), errorText: l10n.passwordNeedsNumber, checkNullOrEmpty: false),
              ]),
            ),
            //a jelszó megerősítése magában a _buildEditableField metódusban van!
            const SizedBox(height: 30),
            _buildSaveButton(),
            _buildDeleteAccountButton(),
          ],
        ),
      ),
    );
  }

  // --- ÚJ PROFILKÉP WIDGET (A levágott bal oldal javítása) ---
  Widget _buildProfilePicture() {
    final l10n = AppLocalizations.of(context)!;

    // Itt hívjuk be az új globális widgetet! (Importálni kell felülre a fájlt)
    // Ha _selectedImage van, akkor azt mutatjuk (File), ha nincs, akkor a mentett URL-t.
    Widget image;
    if (_selectedImage != null) {
      image = CircleAvatar(radius: 60, backgroundImage: FileImage(_selectedImage!));
    } else {
      image = CustomAvatar(imageUrl: _profilePicture, radius: 60);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 12),
              child: Text(
                l10n.profilePicture,
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 1),
              ),
            ),
            IconButton(
              onPressed: _pickImage,
              icon: const Icon(Icons.edit, color: Colors.deepPurpleAccent),
            ),
          ],
        ),
        // Eltűnt a ClipOval, a CustomAvatar megoldja a kört!
        image,
      ],
    );
  }

  // Widget _buildProfilePicture() {
  //   final l10n = AppLocalizations.of(context)!;
  //   //cachelt képekből felépítjük a profilképet
  //   Widget image;
  //
  //   if (_cachedSvgBytes != null) {
  //     image = SvgPicture.memory(
  //       _cachedSvgBytes!,
  //       width: 120,
  //       height: 120,
  //       fit: BoxFit.fill,
  //     );
  //   } else if (_cachedProfileImage != null) {
  //     image = ClipOval(
  //       child: Image(
  //         image: _cachedProfileImage!,
  //         width: 120,
  //         height: 120,
  //         fit: BoxFit.fill,
  //       ),
  //     );
  //   } else {
  //     // ToastMessages.showToastMessages(
  //     //   Preferences.isHungarian ? "Ismeretlen MIME-típus a profilképnél!" : "An unknown MIME type has been detected!",
  //     //   0.2,
  //     //   Colors.redAccent,
  //     //   Icons.error,
  //     //   Colors.black,
  //     //   const Duration(seconds: 2),
  //     //   context,
  //     // );
  //     log("Ismeretlen MIME-típus a profilképnél: $_profilePicture");
  //     image = _defaultAvatar();
  //   }
  //
  //   //majd ezzel térünk vissza
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Row(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.only(bottom: 5, top: 12),
  //             child: Text(
  //               l10n.profilePicture,
  //               style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.w600,
  //                 letterSpacing: 1,
  //               ),
  //             ),
  //           ),
  //           IconButton(
  //             //megnyomásra megjelenik a képválasztó
  //             onPressed: _pickImage,
  //             icon: const Icon(
  //               Icons.edit,
  //               color: Colors.deepPurpleAccent,
  //             ),
  //           ),
  //         ],
  //       ),
  //       ClipOval(child: image),
  //     ],
  //   );
  // }

  Widget _buildEditableField({
    //meghíváskor kell megadni a mezőket (köztük a hosszú validátorokat is)
    //mivel így nincsen duplikált kód (a jelszó megerősítése itt található, mert egyszerre jelenik meg a password-al)
    required String title,
    required String fieldName,
    required String? initialValue,
    required bool isEditing,
    required FocusNode focusNode,
    required bool focusVariable,
    required TextEditingController controller,
    required TextInputType? keyboardType,
    required VoidCallback onEditToggle,
    //ezek a nem kötelező mezők mind a jelszó input mező megjelenéséért felelnek
    bool? obscureText,
    VoidCallback? onVisibilityToggle,
    String? helperText,
    TextStyle? helperStyle,
    required String? Function(String?) validator,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //nem jelenítünk meg title-t és ceruza ikont se mert a jelszó mező már felfogja építeni
        if (fieldName != "password_confirm")
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.deepPurpleAccent,
                ),
                onPressed: onEditToggle,
              ),
            ],
          ),
        if (isEditing) ...[
          //megnyitáskor ez történik:
          FormBuilderTextField(
            name: fieldName,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            focusNode: focusNode,
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText ?? false,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: _decorationForInput(
              //ha nincs megadva onVisibilityToggle tehát nem jelszó mező (email, username):
              (onVisibilityToggle == null)
                  //akkor csak a tartalom törlő ikon jelenhet meg
                  ? (controller.text.isNotEmpty ? _buildDeleteContentIcon(controller) : null)
                  : Row(
                      //különben pedig a törlő ikon és a jelszó láthatósági ikon
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (controller.text.isNotEmpty) _buildDeleteContentIcon(controller),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: GestureDetector(
                            //meghíváskor adjuk meg mit csináljon, mert sajnos itt ha változóval adnánk át nem működne
                            onTap: onVisibilityToggle,
                            child: Icon(
                              obscureText! ? Icons.visibility_off : Icons.visibility,
                            ),
                          ),
                        ),
                      ],
                    ),
              //többi elem a _decorationForInput mezőhöz (ez a hosszú csak a suffixIcon volt :) )
              controller,
              title,
              focusVariable,
              helperText,
              helperStyle,
            ),
          ),
          if (fieldName == "password")
            //pluszba építsen 1-et fel ha a felépített mező a password neven van
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _buildEditableField(
                title: l10n.confirmPassword,
                fieldName: "password_confirm",
                initialValue: null,
                isEditing: _isEditingPassword,
                focusNode: _passwordConfirmFocusNode,
                focusVariable: _isPasswordConfirmFocused,
                controller: _passwordConfirmController,
                keyboardType: null,
                onEditToggle: () {
                  setState(() {
                    _isEditingPassword = !_isEditingPassword;
                  });
                },
                obscureText: _isPasswordConfirmNotVisible,
                onVisibilityToggle: () {
                  setState(() {
                    _isPasswordConfirmNotVisible = !_isPasswordConfirmNotVisible;
                  });
                },
                helperText: null,
                helperStyle: null,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: l10n.fieldMustMatchPassword, checkNullOrEmpty: true),
                  FormBuilderValidators.equal(_passwordController.text, errorText: l10n.passwordsDoesntMatch, checkNullOrEmpty: true),
                ]),
              ),
            ),
        ] else
          //ha nem true az isEditing akkor pedig ez jelenjen meg (alapértelmezett érték)
          _buildIfEditingIsNotTrue(initialValue),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDeleteContentIcon(TextEditingController controller) {
    //ezt hívjuk meg a _buildEditableField-nél és a tartalom törlésért felel
    return GestureDetector(
      onTap: () => controller.clear(),
      child: const Icon(
        Icons.clear_rounded,
        color: Colors.white,
      ),
    );
  }

  InputDecoration _decorationForInput(
      //egységes dekoráció, kódismétlés nélkül
      Widget? suffixIcon,
      TextEditingController controller,
      String title,
      bool focusVariable,
      String? helperText,
      TextStyle? helperStyle) {
    return InputDecoration(
      suffixIcon: suffixIcon,
      hintText: focusVariable ? null : title,
      hintStyle: TextStyle(
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      labelText: focusVariable ? title : null,
      labelStyle: const TextStyle(
        color: Colors.white,
        letterSpacing: 1.0,
      ),
      helperText: helperText,
      helperStyle: helperStyle,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 2.5,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.deepPurpleAccent,
          width: 2.5,
        ),
      ),
    );
  }

  Widget _buildIfEditingIsNotTrue(String? initialValue) {
    //ha nincs megjelenítve az input mező akkor a megadott alapértelmezett értéket írja ki (ha nincs akkor üres string)
    return AutoSizeText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      initialValue ?? "",
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 16,
      ),
    );
  }

  Widget _buildSaveButton() {
    final l10n = AppLocalizations.of(context)!;
    //ez a gomb hívja meg a _handleSave-et, csak akkor aktív ha van legalább 1 validált változtatás (profilképet is beleértve)!
    return Column(
      children: [
        ElevatedButton(
          onPressed: _isFormValid ? _handleSave : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            shadowColor: Colors.deepPurpleAccent,
            disabledBackgroundColor: Colors.grey[700],
            elevation: _isFormValid ? 5 : 0,
          ),
          child: Text(
            l10n.saveChanges,
            style: const TextStyle(
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteAccountButton() {
    final l10n = AppLocalizations.of(context)!;
    //ez pedig a törlés dialógust hívja meg ami majd a törlést
    return TextButton.icon(
      icon: const Icon(
        Icons.delete_forever,
        color: Colors.redAccent,
      ),
      label: Text(
        l10n.deleteAccount,
        style: const TextStyle(
          color: Colors.redAccent,
        ),
      ),
      onPressed: _confirmAccountDeletion,
    );
  }

  void _confirmAccountDeletion() {
    //TODO: kiemelni ezt is
    final l10n = AppLocalizations.of(context)!;
    //megerősítő felület, ha Törlés-re nyom akkor lefut a törlő metódus
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          elevation: 10,
          shadowColor: Colors.deepPurpleAccent,
          title: Text(
            l10n.areYouSureDeleteAccount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: Text(
            l10n.actionCannotUndone,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          actions: [
            TextButton(
              //ha "Mégse" akkor csak lépjen ki a dialog-ból
              child: Text(
                l10n.cancel,
                style: const TextStyle(
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              //törlésnél pedig hívja meg a törlő metódust és lépjen ki a dialógusból
              child: Text(
                l10n.delete,
                style: const TextStyle(
                  color: Colors.redAccent,
                  letterSpacing: 1,
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await _deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  // Widget _defaultAvatar() {
  //   //ha nincs megfelelő profilkép (betöltve) akkor mi jelenjen meg
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 15, right: 20),
  //     child: CircleAvatar(
  //       radius: 60,
  //       backgroundColor: Colors.grey[600],
  //       child: const Icon(
  //         Icons.person,
  //         size: TODO: 50 helyett mostmár radius * 1,3 van
  //         color: Colors.white,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDivider() {
    final l10n = AppLocalizations.of(context)!;
    //ez a widget felépít egy elválasztót (szöveggel) a kategóriák között (későbbi verziókban bővülni fog!)
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5, left: 8),
          child: Text(
            l10n.accountDetails,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//AccountSetting OSZTÁLY VÉGE ---------------------------------------------------------------------
