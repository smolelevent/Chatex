import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:chatex/main/sign_up.dart';
import 'package:chatex/main/reset_password.dart';
import 'package:chatex/application/components_of_chat/build_ui.dart';
import 'package:chatex/logic/notifications.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/logic/auth.dart';
import 'dart:developer';
import 'dart:convert';

//AZ XAMPP-OT futtatni kell használat előtt (ha nem indul el akkor setup_xampp.bat-ot kell futtatni!), illetve...
//A Websocket Server-t is futtatni kell indítás előtt (a terminálon keresztűl a megadott elérési úttal és paranccsal!)
//parancs: xampp_server\htdocs\ChatexProject\chatex_phps> php server_run.php

//GLOBÁLIS METÓDUSOK ELEJE ------------------------------------------------------------------------
Future<void> main() async {
  //ez a metódus az alap metódus, ez indítja el a Chatex alkalmazást,
  //de nem csak elindítja hanem mást is csinál:

  //ez a változó eltárolja azt hogy a Widgets framework és a Flutter engine között lévő kapcsolat
  //biztosan hogy létre legyen hozva!
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  //ahoz hogy megfelelő időben, jelenjen meg a splash screen (az alkalmazás indításakor),
  //ahoz a widgetsBinding-ot biztosítani kell hogy inicializált legyen!!
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //inicializáljuk közben a kettő osztályunkat: a Preferences-t (lokális tárolás)
  //és a NotificationService-t (értesítések)
  await Preferences.init();
  await NotificationService.initialize();

  //amikor már betöltött az alkalmazás tűntesse el a splash screen-t
  FlutterNativeSplash.remove();

  //megnézi, majd eltároljuk a tryAutoLogin metódus eredményét,
  //ami a token alapú (preferences osztály) bejelentkezve maradáshoz szükséges!
  final isLoggedIn = await tryAutoLogin();

  //végül elindítja az alkalmazást,
  //ami a isLoggedIn változó alapján vagy a build_ui.dart-ra visz, vagy a main.dart-on hagy!
  runApp(MaterialApp(
    home: isLoggedIn ? const ChatUI() : const LoginUI(),
  ));
}

Future<bool> tryAutoLogin() async {
  //ez a metódus nézi meg hogy érvényes e még a felhasználó token-je
  //és az alapján dönti el hogy melyik képernyő legyen betöltve
  final token = Preferences.getToken();

  try {
    final response = await http.post(
      Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/auth/validate_token.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": token}),
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData["success"] == true) {
      //ha sikeres volt az ellenőrzés akkor elmentjük újra az adatokat lokálisan a tokenből kinyerve!
      Preferences.setUserId(responseData["id"]);
      Preferences.setPreferredLanguage(responseData["preferred_lang"]);
      Preferences.setProfilePicture(responseData["profile_picture"]);
      Preferences.setUsername(responseData["username"]);
      Preferences.setEmail(responseData["email"]);
      Preferences.setPasswordHash("password_hash");
      return true;
    }
  } catch (e) {
    log("Hiba a token validálásakor: ${e.toString()}");
  }

  return false;
}

//GLOBÁLIS METÓDUSOK VÉGE -------------------------------------------------------------------------

//LoginUI OSZTÁLY ELEJE ---------------------------------------------------------------------------

class LoginUI extends StatefulWidget {
  const LoginUI({
    super.key,
  });

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  //TextEditingController típusú változókba tároljuk el az input mezők tartalmát
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //FocusNode-okkal vizsgáljuk ha az input mezőkön van fókusz vagy nincs,
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  //amiket bool változókba tároljuk el, hogy később dizájn változtatást tudjunk előidézni
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  //ez a változó pedig azért felel hogy váltakozni tudjon a szem ikon megnyomására a jelszó,
  //rendes és pontozott tartalom között!
  bool _isPasswordNotVisible = true;

  //a mezők validálását tudjuk vizsgálni a _formKey segítségével
  final _formKey = GlobalKey<FormBuilderState>();
  //alapértelmezetten NINCS engedélyezve a Bejelentkezés gomb, mivel vagy nincsenek vagy hibásak az adatok!
  bool _isLogInDisabled = true;

  //ha már volt bejelentkezve/regisztrálva/tokenből kinyerve a preferált nyelv akkor aszerint mutatjuk a szövegeket!
  String _selectedLanguage = Preferences.getPreferredLanguage();

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  @override
  void initState() {
    //inicializáljuk a Flutter engine alapértelmezett dolgait, majd
    super.initState();

    //a FocusNodeok-hoz hozzácsatoljuk a bool változóinkat, ha azok a mezők fókuszt kapnak!
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
  }

  @override
  void dispose() {
    super.dispose(); //alapértelmezett erőforrás takarítást végez el a dispose

    //és disposeol-juk azokat a változókat is amik már nincsenek használatban (pl.: másik képernyő)
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    //alapértelmezetten frissít minden dependencyt, ha megváltozott valami benne (rebuild helyett)
    super.didChangeDependencies();

    //FlutterToast-hoz is kell, hogy mindenhol megtudjon jelenni, bármikor!
    ToastMessages.init(context);
  }

  void _checkLoginFieldsValidation() {
    //ez a metódus felel azért hogy a FormBuilder által létrehozott FormBuilderTextField-ek
    //megfelelően legyenek validálva és megfelelően legyen kezelve a bejelentkezés gomb!

    //a _formKey-en keresztűl vehetjük ki a email és a jelszó mező tulajdonságait
    final currentState = _formKey.currentState;
    //ha ez üres akkor térjen is vissza!
    if (currentState == null) return;

    //explicit validálás (ez frissíti is a mezőket vizuálisan! Illetve ha van rossz érték akkor ne ugorjon egyből oda)
    final isValid = currentState.validate(focusOnInvalid: false);

    //lekérjük a mezők értékeit név alapján
    final emailValue = currentState.fields['email']?.value?.trim() ?? '';
    final passwordValue = currentState.fields['password']?.value?.trim() ?? '';

    //és ha egyik érték sem üres akkor...
    final allFilled = emailValue.isNotEmpty && passwordValue.isNotEmpty;

    setState(() {
      //a bejelentkezés gomb állapotát frissítjük valid és nem üres mezőkkel
      //azért kell a !-el megfordítani mert alapértelmezetten false-ra van állítva!
      _isLogInDisabled = !(isValid && allFilled);
    });
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //megakadályozza hogy az expanded mezők (regisztráció és Chatex szöveg ne csússzon fel íráskor)
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[850],
        body: _buildBody(),
      ),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  Widget _buildDropdownMenu() {
    //ez a metódus felépíti a nyelvválasztó menüt ami jelenleg magyart és angolt tartalmaz
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 20),
      child: DropdownMenu<String>(
        //nem kaphat fókuszt, mert akkor keresni lehetne a tartalma között (2 értéknél felesleges)
        requestFocusOnTap: false,
        label: Text(
          _selectedLanguage == "Magyar" ? "Nyelvek" : "Languages",
        ),
        //az alapértelmezett érték a preferált nyelv legyen (Magyar/English),
        //ami megegyezik az entry-k value property-ével
        initialSelection: _selectedLanguage,
        onSelected: (newValue) {
          //newValue egy lokális változó amit a DropdownMenu kezel és az entry-k value-it tartalmazza!
          setState(() {
            _selectedLanguage = newValue!;
          });
        },
        dropdownMenuEntries: [
          _buildDropdownMenuEntry("Magyar", "Magyar"),
          _buildDropdownMenuEntry("English", "English"),
        ],
        //a DropdownMenu végén elhelyezkedő gombok állandó
        trailingIcon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        //és fókuszált állapotban
        selectedTrailingIcon: const Icon(
          Icons.arrow_drop_up,
          color: Colors.deepPurpleAccent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          //a DropdownMenu kínézetét adja meg
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.deepPurpleAccent,
              width: 2.5,
            ),
          ),
        ),
        textStyle: const TextStyle(
          //a megjelenített szöveg stílusát állítja
          color: Colors.white,
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        menuStyle: const MenuStyle(
          //a megnyitáskor megjelenő menü stílusa
          backgroundColor: WidgetStatePropertyAll(Colors.deepPurpleAccent),
          elevation: WidgetStatePropertyAll(5),
        ),
      ),
    );
  }

  DropdownMenuEntry<String> _buildDropdownMenuEntry(
      dynamic value, String label) {
    //ez a metódus felel maga a kiválasztható értékek megjelenítéséért!
    return DropdownMenuEntry(
      style: TextButton.styleFrom(
        //a stílus a lenyitáskor jelenik meg
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
      ),
      value: value,
      label: label,
    );
  }

  Widget _buildBody() {
    return FormBuilder(
      key: _formKey,
      onChanged: () {
        //minden változásnál nézzük az értékeket
        _checkLoginFieldsValidation();
      },
      child: Column(
        children: [
          _buildDropdownMenu(),
          const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage("assets/logo/logo.jpg"),
          ),
          Column(
            children: [
              _buildEmailWidget(),
              _buildPasswordWidget(),
              const SizedBox(
                height: 10.0,
              ),
              _buildLoginButton(),
              const SizedBox(
                height: 5.0,
              ),
              _buildForgotPasswordButton(),
            ],
          ),
          _buildRegistrationButton(),
          _chatexWidget(),
        ],
      ),
    );
  }

  Widget _buildEmailWidget() {
    //ez a metódus felépíti az email FormBuilderTextField mezőt amit
    //a name property alapján beazonosít a FormBuilder (azzal tudunk hivatkozni rá!)
    return Container(
      margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
      child: FormBuilderTextField(
        key: const Key("email"),
        name: "email",
        //a validálás csak akkor történik ha a felhasználó elkezd írni
        autovalidateMode: AutovalidateMode.onUserInteraction,
        //ezek alapján:
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.email(
              regex: RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                unicode: true,
              ),
              errorText: _selectedLanguage == "Magyar"
                  ? "Az email cím érvénytelen!"
                  : "The email address is invalid!",
              checkNullOrEmpty: false),
        ]),
        focusNode: _emailFocusNode,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        //meghívjuk a saját egységes, passwordnál is használt InputDecorationünk-et
        decoration: _decorationForInput(
            _emailController,
            _selectedLanguage == "Magyar" ? "E-mail cím" : "E-mail address",
            _isEmailFocused),
      ),
    );
  }

  Widget _buildPasswordWidget() {
    //ugyanarra a mintára alakítjuk ki, mint az email mezőt!
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: FormBuilderTextField(
        key: const Key("password"),
        name: "password",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.minLength(8,
              errorText: _selectedLanguage == "Magyar"
                  ? "A jelszó túl rövid! (min 8 karakter)"
                  : "The password is too short! (min 8 characters)",
              checkNullOrEmpty: false),
          FormBuilderValidators.maxLength(20,
              errorText: _selectedLanguage == "Magyar"
                  ? "A jelszó túl hosszú! (max 20 karakter)"
                  : "The password is too long! (max 20 characters)",
              checkNullOrEmpty: false),
          FormBuilderValidators.hasUppercaseChars(
              atLeast: 1,
              regex: RegExp(r'\p{Lu}', unicode: true),
              errorText: _selectedLanguage == "Magyar"
                  ? "A jelszónak legalább 1 nagybetűt tartalmaznia kell!"
                  : "The password must contain at least 1 uppercase letter!",
              checkNullOrEmpty: false),
          FormBuilderValidators.hasLowercaseChars(
              atLeast: 1,
              regex: RegExp(r'\p{Ll}', unicode: true),
              errorText: _selectedLanguage == "Magyar"
                  ? "A jelszónak legalább 1 kisbetűt tartalmaznia kell!"
                  : "The password must contain at least 1 lowercase letter!",
              checkNullOrEmpty: false),
          FormBuilderValidators.hasNumericChars(
              atLeast: 1,
              regex: RegExp(r'[0-9]', unicode: true),
              errorText: _selectedLanguage == "Magyar"
                  ? "A jelszónak legalább 1 számot tartalmaznia kell!"
                  : "The password must contain at least 1 number!",
              checkNullOrEmpty: false),
        ]),
        focusNode: _passwordFocusNode,
        controller: _passwordController,
        obscureText: _isPasswordNotVisible,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: _decorationForInput(
          _passwordController,
          _selectedLanguage == "Magyar" ? "Jelszó" : "Password",
          _isPasswordFocused,
          onVisibilityToggle: () {
            setState(() {
              _isPasswordNotVisible = !_isPasswordNotVisible;
            });
          },
          obscureText: _isPasswordNotVisible,
        ),
      ),
    );
  }

  InputDecoration _decorationForInput(
    TextEditingController controller,
    String title,
    bool focusVariable, {
    VoidCallback? onVisibilityToggle,
    bool? obscureText,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      suffixIcon: (onVisibilityToggle == null)
          //ha nincs megadva a onVisibilityToggle metódus akkor csak a tartalom törlő gomb lesz a suffix helyén (email mező),
          ? (controller.text.isNotEmpty
              ? _buildDeleteContentIcon(controller)
              : null)
          //de ha megadjuk akkor már a password visibility ikon is megfog jelenni (állandóan), míg a tartalom törlő csak tartalomnál!
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.text.isNotEmpty)
                  _buildDeleteContentIcon(controller),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: GestureDetector(
                    onTap: onVisibilityToggle,
                    child: Icon(
                      obscureText! ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              ],
            ),
      hintText: focusVariable ? null : title,
      hintStyle: TextStyle(
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
      labelText: focusVariable ? title : null,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        letterSpacing: 1.0,
      ),
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

  Widget _buildDeleteContentIcon(TextEditingController controller) {
    //ezt hívjuk a _decorationForInput-nál, ami a tartalom törlést jeleníti meg
    return GestureDetector(
      onTap: () => controller.clear(),
      child: const Icon(
        Icons.clear_rounded,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLoginButton() {
    //bejelentkezés gomb, dinamikus frissítéssel
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              key: const Key("logIn"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                //ha _isLogInDisabled = true, akkor ki van kapcsolva amit az onPressed alapján tud meg a gomb!
                disabledBackgroundColor: Colors.grey[700],
                disabledForegroundColor: Colors.white,
                elevation: 5,
              ),
              onPressed: _isLogInDisabled
                  ? null
                  : () async {
                      //bezárjuk a billentyűzetet hogy ne legyen lag és hogy látszódjön a toast üzenet!
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.saveAndValidate()) {
                        //elmentjük az adatokat, majd elküldjük az AuthService-nek
                        await AuthService().logIn(
                          email: _emailController,
                          password: _passwordController,
                          context: context,
                          language: _selectedLanguage,
                        );
                      }
                    },
              child: Text(
                _selectedLanguage == "Magyar" ? "Bejelentkezés" : "Login",
                style: const TextStyle(
                  fontSize: 20,
                  height: 3.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        //nyomásra átvisz a reset_password.dart-ra
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPasswordPage(
              language: _selectedLanguage,
            ),
          ),
        );
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
      ),
      child: Text(
        _selectedLanguage == "Magyar"
            ? "Elfelejtett jelszó"
            : "Forgot password",
      ),
    );
  }

  Widget _buildRegistrationButton() {
    //Align widgettel lent és középre igazítottuk és Expanded widget-tel (első) ott tartjuk
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            Expanded(
              //a gomb szélességéért felel csak
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  bottom: 20.0,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    //regisztráció képernyőre visz a gomb, átadjuk a nyelvet hogy megfelelően jelenjen meg a tartalom
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUp(
                          language: _selectedLanguage,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    elevation: 5,
                  ),
                  child: Text(
                    _selectedLanguage == "Magyar"
                        ? "Új fiók létrehozása"
                        : "Create a new account",
                    style: const TextStyle(
                      fontSize: 20,
                      height: 3.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatexWidget() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Chatex",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}
//LoginUI OSZTÁLY VÉGE ----------------------------------------------------------------------------
