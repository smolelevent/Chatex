import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:chatex/main.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/logic/toast_message.dart';
import 'dart:typed_data';
import 'dart:developer';
import 'dart:convert';
import 'dart:io';

//AccountSetting OSZTÁLY ELEJE --------------------------------------------------------------------
class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

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

  final TextEditingController _passwordConfirmController =
      TextEditingController();
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

  //cacheléshez szükséges változók (hogy a profilkép minden képernyő frissítéskor ne pislákoljon)
  ImageProvider? _cachedProfileImage;
  Uint8List? _cachedSvgBytes;

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _cacheProfileImage();

    //FocusNode-okat össze kötjük a bool változójukkal

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

  void _cacheProfileImage() {
    //cacheljük a profilképet hogy ne "pislálkoljon"
    if (_profilePicture!.startsWith("data:image/svg+xml;base64,")) {
      _cachedSvgBytes = base64Decode(_profilePicture!.split(",")[1]);
      _cachedProfileImage = null;
    } else if (_profilePicture!.startsWith("data:image/")) {
      final base64Data = base64Decode(_profilePicture!.split(",")[1]);
      _cachedProfileImage = MemoryImage(base64Data);
      _cachedSvgBytes = null;
    }
  }

  void _onAnyFieldValid() {
    //ez dönti el hogy engedélyezve legyen a mentés gomb vagy sem
    //minden input változásnál lefut
    final currentState = _formKey.currentState;
    if (currentState == null) return;

    currentState.save(); // Ez azért kell, hogy az értékeket is le tudjunk kérni

    final isUsernameValid =
        currentState.fields['username']?.validate() ?? false;
    final isEmailValid = currentState.fields['email']?.validate() ?? false;

    // Jelszónál dupla feltétel: csak akkor nézzük, ha a megerősítő jelszó is valid
    final isPasswordValid =
        (currentState.fields['password']?.validate() ?? false) &&
            (currentState.fields['password_confirm']?.validate() ?? false);

    // Profilkép változás ha a kiválasztott kép nem üres
    final hasNewProfilePicture = _selectedImage != null;

    //bármelyik is igaz
    final atLeastOneValid = isUsernameValid ||
        isEmailValid ||
        isPasswordValid ||
        hasNewProfilePicture;

    setState(() {
      //átadjuk a gombot engedélyező változónak
      _isFormValid = atLeastOneValid;
    });
  }

  Future<void> _updateUsername(String newUsername) async {
    //ez a metódus frissíti a felhasználónevet a megadott string-el
    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/settings/account/update_username.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": Preferences.getUserId(),
          "username": newUsername,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData["status"] == "success") {
        //lokálisan is frissítjük a nevet
        await Preferences.setUsername(newUsername);

        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Felhasználónév sikeresen frissítve!"
              : "Username updated successfully!",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      } else {
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Hiba történt a felhasználónév frissítésekor!"
              : "Failed to update username!",
          0.2,
          Colors.redAccent,
          Icons.error_rounded,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a\nfelhasználónév módosítása közben!"
            : "Connection error while\nupdating username!",
        0.2,
        Colors.redAccent,
        Icons.error_rounded,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Kapcsolati hiba a felhasználónév módosítása közben! ${e.toString()}");
    }
  }

  Future<void> _updateEmail(String newEmail) async {
    //ez a metódus frissíti az email címet a megadott id és string alapján
    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/settings/account/update_email.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": Preferences.getUserId(),
          "email": newEmail,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData["status"] == "success") {
        //lokális mentés
        await Preferences.setEmail(newEmail);
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Email sikeresen frissítve!"
              : "Email updated successfully!",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      } else {
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Hiba történt az email frissítésekor!"
              : "Failed to update email!",
          0.2,
          Colors.redAccent,
          Icons.error_rounded,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba az\nemail frissítése közben!"
            : "Connection error while\nupdating email!",
        0.2,
        Colors.redAccent,
        Icons.error_rounded,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Kapcsolati hiba az email frissítése közben! ${e.toString()}");
    }
  }

  Future<void> _updatePassword(String newPassword) async {
    //jelszó frissítés
    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/settings/account/update_password.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": Preferences.getUserId(),
          "password": newPassword,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData["status"] == "success") {
        //ezt nem mentjük el lokálisan, mert nem tároljuk biztonsági okok miatt
        ToastMessages.showToastMessages(
          Preferences.isHungarian ? "Jelszó frissítve!" : "Password updated!",
          0.2,
          Colors.green,
          Icons.check_rounded,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      } else {
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Hiba a jelszó frissítése közben!"
              : "Password update failed!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a\njelszó frissítése közben!"
            : "Connection error while\nupdating password!",
        0.2,
        Colors.redAccent,
        Icons.error_rounded,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Kapcsolati hiba a jelszó frissítése közben! ${e.toString()}");
    }
  }

  Future<void> _pickImage() async {
    //ez a metódus felel a képkiválasztásért

    if (_isPickingImage) return; // ha már fut, akkor kilépünk

    setState(() {
      _isPickingImage = true;
    });

    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        setState(() {
          _isPickingImage = false;
        });
        return;
      }

      final filePath = pickedFile.path;
      final fileExtension = filePath.split('.').last.toLowerCase();
      final supportedExtensions = ['svg', 'png', 'jpg', 'jpeg'];

      if (!supportedExtensions.contains(fileExtension)) {
        //ha nem támogatott formátum lett kiválasztva
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Nem támogatott fájlformátum!"
              : "Unsupported file format!",
          0.2,
          Colors.red,
          Icons.image,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
        setState(() {
          //engedjük hogy újra megnyissa a kép választót
          _isPickingImage = false;
        });
        return;
      }

      final file = File(filePath);
      final bytes = await file.readAsBytes();

      //base64-es kódolás amihez hozzátesszük a mimeType-ot
      final base64 = base64Encode(bytes);

      String mimeType;
      switch (fileExtension) {
        case "svg":
          mimeType = "data:image/svg+xml;base64,";
          break;
        case "png":
          mimeType = "data:image/png;base64,";
          break;
        case "jpg":
          mimeType = "data:image/jpg;base64,";
          break;
        case "jpeg":
          mimeType = "data:image/jpeg;base64,";
          break;
        default:
          mimeType = "";
      }

      setState(() {
        //frissítjük mind a kettő változót, és már az új profilkép fog megjelenni
        _selectedImage = file;
        _profilePicture = "$mimeType$base64";
        _isPickingImage = false; // itt is vissza állítjuk
      });

      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kép kiválasztva! Most módosíthatod!"
            : "Image selected! You can now update it!",
        0.2,
        Colors.orange,
        Icons.image,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );

      //frissítjük a mentés gombot
      _onAnyFieldValid();

      //frissítsük a cache-t is
      _cacheProfileImage();
    } catch (e) {
      setState(() {
        _isPickingImage = false;
      });
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Hiba a kép kiválasztásánál!"
            : "Error while selecting image!",
        0.2,
        Colors.redAccent,
        Icons.image,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      log("Hiba kép kiválasztásánál: ${e.toString()}");
    }
  }

  Future<void> _updateProfilePicture() async {
    //csak akkor frissítünk, ha volt kiválasztott kép
    if (_selectedImage == null || _profilePicture == null) return;

    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/settings/account/update_profile_picture.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": Preferences.getUserId(),
          "profile_picture": _profilePicture,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData["status"] == "success") {
        //lokálisan is frissítjük
        await Preferences.setProfilePicture(_profilePicture!);

        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Profilkép sikeresen frissítve!"
              : "Profile picture updated successfully!",
          0.2,
          Colors.green,
          Icons.check_rounded,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      } else {
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Hiba történt a profilkép frissítésekor!"
              : "Failed to update profile picture!",
          0.2,
          Colors.redAccent,
          Icons.error_rounded,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a\nprofilkép frissítése közben!"
            : "Connection error while\nupdating profile picture!",
        0.2,
        Colors.redAccent,
        Icons.error_rounded,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Kapcsolati hiba a profilkép frissítése közben! ${e.toString()}");
    }
  }

  Future<void> _handleSave() async {
    //ez a metódus felel az összes frissítő metódus meghívásáért

    //bezárjuk a billentyűzetet
    FocusScope.of(context).unfocus();

    //eltároljuk az új értékekeket
    final newUsername =
        _formKey.currentState!.fields["username"]?.value?.trim() ?? '';
    final newEmail =
        _formKey.currentState!.fields["email"]?.value?.trim() ?? '';
    final newPassword =
        _formKey.currentState!.fields["password"]?.value?.trim() ?? '';

    //összehasonlítást végzünk az új és a régi értékek között
    //és csak akkor engedlyük frissíteni ha nem ugyanaz (kivéve a jelszónál mert azt alapból nem tároljuk)
    final oldUsername = Preferences.getUsername();
    final oldEmail = Preferences.getEmail();

    //minden frissítés után ezt igazra váltjuk
    bool somethingChanged = false;

    //felhasználónév frissítése
    if (newUsername.isNotEmpty &&
        newUsername != oldUsername &&
        newUsername != null) {
      await _updateUsername(newUsername);
      somethingChanged = true;
    }

    //email frissítése
    if (newEmail.isNotEmpty && newEmail != oldEmail && newEmail != null) {
      await _updateEmail(newEmail);
      somethingChanged = true;
    }

    //jelszó frissítése (lehet ugyanarra változtatni a jelszót, de azt már nem tudtam megoldani hogy ne lehessen)
    if (newPassword.isNotEmpty && newPassword != null) {
      await _updatePassword(newPassword);
      somethingChanged = true;
    }

    //profilkép frissítése (csak azt nézzük ha van kiválasztott új kép)
    if (_selectedImage != null) {
      await _updateProfilePicture();
      somethingChanged = true;
    }

    if (somethingChanged) {
      //és ha sikerült legalább 1 módosítás akkor visszajelzést adunk a felhasználónak
      ToastMessages.showToastMessages(
        Preferences.isHungarian ? "Módosítások elmentve!" : "Changes saved!",
        0.2,
        Colors.deepPurpleAccent,
        Icons.check,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );

      setState(() {
        //majd bezárunk mindent
        _isEditingUsername = false;
        _isEditingEmail = false;
        _isEditingPassword = false;

        //töröljük a kiválasztott képet és kikapcsoljuk a gombot
        _selectedImage = null;
        _isFormValid = false;
      });

      //illetve töröljük a mezők tartalmát
      _formKey.currentState!.reset();
      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _passwordConfirmController.clear();
    } else {
      //különben (felhasználónév és email esetében)
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Nem lehet ugyanarra módosítani!"
            : "Can't modify to the same value(s)!",
        0.2,
        Colors.redAccent,
        Icons.error_rounded,
        Colors.black,
        const Duration(seconds: 4),
        context,
      );
    }
  }

  Future<void> _deleteAccount() async {
    //ez a metódus a megerősítés után törli a fiókot
    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/settings/account/delete_user.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": Preferences.getUserId()}),
      );

      final responseData = jsonDecode(response.body);

      if (responseData["success"] == true) {
        ToastMessages.showToastMessages(
          Preferences.isHungarian ? "Fiók törölve!" : "Account deleted!",
          0.3,
          Colors.green,
          Icons.check_rounded,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );

        //lokálisan is törlünk mindent!
        await Preferences.clearPreferences();

        if (context.mounted) {
          //és 3 másodperc várakozás után vissza írányítjuk a bejelentkezési képernyőre!
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginUI()),
              (route) => false,
            );
          });
        }
      } else {
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Hiba a fiók törlésénél!"
              : "Error deleting account!",
          0.3,
          Colors.redAccent,
          Icons.error_rounded,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a\nfiók törlése közben!"
            : "Connection error while\ndeleting account!",
        0.2,
        Colors.redAccent,
        Icons.error_rounded,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Kapcsolati hiba a fiók törlése közben! ${e.toString()}");
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

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      title: AutoSizeText(
        Preferences.isHungarian ? "Fiók kezelése" : "Account managment",
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
    return SingleChildScrollView(
      //scrollolhatóvá teszi a képernyőt, ha nem fér ki valami
      padding: const EdgeInsets.all(16),
      child: FormBuilder(
        key: _formKey,
        onChanged: _onAnyFieldValid,
        child: Column(
          children: [
            _buildDivider(
                Preferences.isHungarian ? "Fiók adatai" : "Account details"),
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
                          title: Preferences.isHungarian
                              ? "Felhasználónév"
                              : "Username",
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
                              3,
                              errorText: Preferences.isHungarian
                                  ? "A felhasználónév\ntúl rövid! (min 3)"
                                  : "The username is\ntoo short! (min 3)",
                              checkNullOrEmpty: false,
                            ),
                            FormBuilderValidators.maxLength(
                              20,
                              errorText: Preferences.isHungarian
                                  ? "A felhasználónév\ntúl hosszú! (max 20)"
                                  : "The username is\ntoo long! (max 20)",
                              checkNullOrEmpty: false,
                            ),
                            FormBuilderValidators.required(
                                errorText: Preferences.isHungarian
                                    ? "A felhasználónév\nnem lehet üres!"
                                    : "The username\ncannot be empty!",
                                checkNullOrEmpty: true),
                          ]),
                        ),
                        _buildEditableField(
                          title:
                              Preferences.isHungarian ? "Email cím" : "Email",
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
                                regex: RegExp(
                                    r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                                    unicode: true),
                                errorText: Preferences.isHungarian
                                    ? "Az email cím\nérvénytelen!"
                                    : "The email address\nis invalid!",
                                checkNullOrEmpty: false),
                            FormBuilderValidators.required(
                                errorText: Preferences.isHungarian
                                    ? "Az email cím\nnem lehet üres!"
                                    : "The email address\ncannot be empty!",
                                checkNullOrEmpty: true),
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
              title: Preferences.isHungarian
                  ? "Jelszó módosítása"
                  : "Change password",
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
              helperText: Preferences.isHungarian
                  ? "Min. 8 karakter, Max. 20 karakter,\n1 kisbetű, 1 nagybetű, és 1 szám."
                  : "Min. 8 characters, Max. 20 characters,\n1 lowercase, 1 uppercase, and 1 number.",
              helperStyle: const TextStyle(
                color: Colors.white,
                letterSpacing: 1.0,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.minLength(8,
                    errorText: Preferences.isHungarian
                        ? "A jelszó túl rövid! (min 8 karakter)"
                        : "The password is too short! (min 8 characters)",
                    checkNullOrEmpty: false),
                FormBuilderValidators.maxLength(20,
                    errorText: Preferences.isHungarian
                        ? "A jelszó túl hosszú! (max 20 karakter)"
                        : "The password is too long! (max 20 characters)",
                    checkNullOrEmpty: false),
                FormBuilderValidators.hasUppercaseChars(
                    atLeast: 1,
                    regex: RegExp(r'\p{Lu}', unicode: true),
                    errorText: Preferences.isHungarian
                        ? "A jelszónak legalább 1 nagybetűt tartalmaznia kell!"
                        : "The password must contain at least 1 uppercase letter!",
                    checkNullOrEmpty: false),
                FormBuilderValidators.hasLowercaseChars(
                    atLeast: 1,
                    regex: RegExp(r'\p{Ll}', unicode: true),
                    errorText: Preferences.isHungarian
                        ? "A jelszónak legalább 1 kisbetűt tartalmaznia kell!"
                        : "The password must contain at least 1 lowercase letter!",
                    checkNullOrEmpty: false),
                FormBuilderValidators.hasNumericChars(
                    atLeast: 1,
                    regex: RegExp(r'[0-9]', unicode: true),
                    errorText: Preferences.isHungarian
                        ? "A jelszónak legalább 1 számot tartalmaznia kell!"
                        : "The password must contain at least 1 number!",
                    checkNullOrEmpty: false),
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

  Widget _buildProfilePicture() {
    //cachelt képekből felépítjük a profilképet
    Widget image;

    if (_cachedSvgBytes != null) {
      image = SvgPicture.memory(
        _cachedSvgBytes!,
        width: 120,
        height: 120,
        fit: BoxFit.fill,
      );
    } else if (_cachedProfileImage != null) {
      image = ClipOval(
        child: Image(
          image: _cachedProfileImage!,
          width: 120,
          height: 120,
          fit: BoxFit.fill,
        ),
      );
    } else {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Ismeretlen MIME-típus a profilképnél!"
            : "An unknown MIME type has been detected!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      log("Ismeretlen MIME-típus a profilképnél: $_profilePicture");
      image = _defaultAvatar();
    }

    //majd ezzel térünk vissza
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 12),
              child: Text(
                Preferences.isHungarian ? "Profilkép" : "Profile picture",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
            IconButton(
              //megnyomásra megjelenik a képválasztó
              onPressed: _pickImage,
              icon: const Icon(
                Icons.edit,
                color: Colors.deepPurpleAccent,
              ),
            ),
          ],
        ),
        ClipOval(child: image),
      ],
    );
  }

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
                  ? (controller.text.isNotEmpty
                      ? _buildDeleteContentIcon(controller)
                      : null)
                  : Row(
                      //különben pedig a törlő ikon és a jelszó láthatósági ikon
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (controller.text.isNotEmpty)
                          _buildDeleteContentIcon(controller),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: GestureDetector(
                            //meghíváskor adjuk meg mit csináljon, mert sajnos itt ha változóval adnánk át nem működne
                            onTap: onVisibilityToggle,
                            child: Icon(
                              obscureText!
                                  ? Icons.visibility_off
                                  : Icons.visibility,
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
                title: Preferences.isHungarian
                    ? "Jelszó újra"
                    : "Confirm password",
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
                    _isPasswordConfirmNotVisible =
                        !_isPasswordConfirmNotVisible;
                  });
                },
                helperText: null,
                helperStyle: null,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: Preferences.isHungarian
                          ? "A mezőnek meg kell egyeznie a jelszó mezővel!"
                          : "The field must match the password field!",
                      checkNullOrEmpty: true),
                  FormBuilderValidators.equal(_passwordController.text,
                      errorText: Preferences.isHungarian
                          ? "A jelszavak nem egyeznek meg!"
                          : "The passwords do not match!",
                      checkNullOrEmpty: true),
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
      suffixIcon,
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
            Preferences.isHungarian ? "Módosítások mentése" : "Save changes",
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
    //ez pedig a törlés dialógust hívja meg ami majd a törlést
    return TextButton.icon(
      icon: const Icon(
        Icons.delete_forever,
        color: Colors.redAccent,
      ),
      label: Text(
        Preferences.isHungarian ? "Fiók törlése" : "Delete Account",
        style: const TextStyle(
          color: Colors.redAccent,
        ),
      ),
      onPressed: _confirmAccountDeletion,
    );
  }

  void _confirmAccountDeletion() {
    //megerősítő felület, ha Törlés-re nyom akkor lefut a törlő metódus
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          elevation: 10,
          shadowColor: Colors.deepPurpleAccent,
          title: AutoSizeText(
            Preferences.isHungarian
                ? "Biztosan törlöd a fiókodat?"
                : "Are you sure you want to delete your account?",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: AutoSizeText(
            Preferences.isHungarian
                ? "Ez a művelet nem visszavonható!"
                : "This action cannot be undone!",
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
                Preferences.isHungarian ? "Mégse" : "Cancel",
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
                Preferences.isHungarian ? "Törlés" : "Delete",
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

  Widget _defaultAvatar() {
    //ha nincs megfelelő profilkép (betöltve) akkor mi jelenjen meg
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 20),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[600],
        child: const Icon(
          Icons.person,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDivider(String title) {
    //ez a widget felépít egy elválasztót (szöveggel) a kategóriák között (későbbi verziókban bővülni fog!)
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5, left: 8),
          child: Text(
            title,
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
