import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:chatex/features/auth/presentation/screens/sign_up.dart';
import 'package:chatex/features/auth/presentation/screens/reset_password.dart';
import 'package:chatex/core/utils/toast_message.dart';
import 'package:chatex/features/auth/data/auth.dart';
import 'package:chatex/core/constants/validation_constants.dart';
import 'package:chatex/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:chatex/core/utils/locale_provider.dart';
import 'package:chatex/core/local_storage/preferences.dart';
import 'package:chatex/core/constants/language_constants.dart';

import 'package:chatex/features/home/presentation/screens/home_screen.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  bool _isPasswordNotVisible = true;

  final _formKey = GlobalKey<FormBuilderState>();

  bool _isLogInDisabled = true;

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  @override
  void initState() {
    //inicializáljuk a Flutter engine alapértelmezett dolgait
    super.initState();

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
    final currentState = _formKey.currentState;
    if (currentState == null) return;

    final isValid = currentState.validate(focusOnInvalid: false);

    final emailValue = currentState.fields['email']?.value?.trim() ?? '';
    final passwordValue = currentState.fields['password']?.value?.trim() ?? '';

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
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLanguageName = localeToLanguage[localeProvider.locale?.languageCode] ?? 'Magyar';

    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 20),
      child: DropdownMenu<String>(
        //nem kaphat fókuszt, mert akkor keresni lehetne a tartalma között (2 értéknél felesleges)
        requestFocusOnTap: false,
        label: Text(
          AppLocalizations.of(context)!.languages,
        ),
        initialSelection: currentLanguageName,
        onSelected: (newLanguageName) {
          if (newLanguageName != null) {
            final newLocaleCode = languageToLocale[newLanguageName] ?? 'hu';
            final newLocale = Locale(newLocaleCode);
            Provider.of<LocaleProvider>(context, listen: false).setLocale(newLocale);
            Preferences.setPreferredLanguage(newLanguageName);
            // TODO: API hívás a szerver felé, hogy az adatbázisban is frissüljön.
          }
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

  DropdownMenuEntry<String> _buildDropdownMenuEntry(dynamic value, String label) {
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
            backgroundImage: AssetImage("assets/images/logo.jpg"),
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
          _buildChatexWidget(),
        ],
      ),
    );
  }

  Widget _buildEmailWidget() {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
      child: FormBuilderTextField(
        key: const Key("email"),
        name: "email",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.email(
              regex: RegExp(
                emailValidationRegex,
                unicode: true,
              ),
              errorText: l10n.emailAddressInvalid,
              checkNullOrEmpty: false),
        ]),
        focusNode: _emailFocusNode,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: _decorationForInput(_emailController, l10n.emailAddress, _isEmailFocused),
      ),
    );
  }

  Widget _buildPasswordWidget() {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: FormBuilderTextField(
        key: const Key("password"),
        name: "password",
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
        focusNode: _passwordFocusNode,
        controller: _passwordController,
        obscureText: _isPasswordNotVisible,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: _decorationForInput(
          _passwordController,
          l10n.password,
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
          ? (controller.text.isNotEmpty ? _buildDeleteContentIcon(controller) : null)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.text.isNotEmpty) _buildDeleteContentIcon(controller),
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
    return GestureDetector(
      onTap: () => controller.clear(),
      child: const Icon(
        Icons.clear_rounded,
        color: Colors.white,
      ),
    );
  }

  // Future<void> closeKeyboardSaveValidateProceedLogin() async {
  //   //bezárjuk a billentyűzetet hogy ne legyen lag és hogy látszódjön a toast üzenet!
  //   FocusScope.of(context).unfocus();
  //   if (_formKey.currentState!.saveAndValidate()) {
  //     //final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
  //     //final language = localeToLanguage[localeProvider.locale?.languageCode] ?? 'Magyar';
  //     // await AuthService()
  //     //     .logIn(email: _emailController, password: _passwordController, context: context, language: language);
  //     await AuthService().logIn(email: _emailController.text.trim(), password: _passwordController.text.trim());
  //   }
  // }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus(); //bezárjuk a billentyűzetet hogy ne legyen lag és hogy látszódjön a toast üzenet!

    if (_formKey.currentState!.saveAndValidate()) {
      final authService = AuthService();
      final l10n = AppLocalizations.of(context)!;

      try {
        await authService.logIn(email: _emailController.text.trim(), password: _passwordController.text.trim());

        if (mounted) {
          ToastMessages.showToastMessages(l10n.successfulLogin, 0.2, Colors.green, Icons.check, Colors.black, const Duration(seconds: 2), context);

          await Future.delayed(const Duration(seconds: 2));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = l10n.error;

          if (e.toString().contains('invalid_credentials')) {
            errorMessage = l10n.loginCredentialsError;
          } else if (e.toString().contains('connection_error')) {
            errorMessage = l10n.connectionErrorLogin;
          }

          ToastMessages.showToastMessages(errorMessage, 0.2, Colors.redAccent, Icons.error, Colors.black, const Duration(seconds: 3), context);
        }
      }
    }
  }

  Widget _buildLoginButton() {
    final l10n = AppLocalizations.of(context)!;

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
                disabledBackgroundColor: Colors.grey[700],
                disabledForegroundColor: Colors.white,
                elevation: 5,
              ),
              onPressed: _isLogInDisabled ? null : _handleLogin,
              child: Text(
                l10n.login,
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
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final language = localeToLanguage[localeProvider.locale?.languageCode] ?? 'Magyar';

    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPasswordScreen(
              language: language,
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
        l10n.forgotPassword,
      ),
    );
  }

  Widget _buildRegistrationButton() {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final language = localeToLanguage[localeProvider.locale?.languageCode] ?? 'Magyar';

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
                          language: language,
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
                    l10n.createNewAccount,
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

  Widget _buildChatexWidget() {
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
