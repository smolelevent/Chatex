import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:chatex/features/auth/data/auth.dart';
import 'package:chatex/l10n/app_localizations.dart';
import 'package:chatex/core/constants/validation_constants.dart';
import 'package:chatex/features/auth/presentation/screens/login_screen.dart';
import 'package:chatex/core/utils/toast_message.dart';

//SignUp OSZTÁLY ELEJE ----------------------------------------------------------------------------
class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.language});

  final String language; //átadjuk itt is a megjelenésért

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  //ugyanaz a minta
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  bool _isUsernameFocused = false;

  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isEmailFocused = false;

  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordFocused = false;
  bool _isPasswordNotVisible = true;

  final TextEditingController _passwordConfirmController = TextEditingController();
  final FocusNode _passwordConfirmFocusNode = FocusNode();
  bool _isPasswordConfirmFocused = false;
  bool _isPasswordConfirmNotVisible = true;

  final _formKey = GlobalKey<FormBuilderState>();
  bool _isRegistrationDisabled = true;

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
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();

    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmFocusNode.dispose();
    super.dispose();
  }

  void _checkRegistrationFieldsValidation() {
    final currentState = _formKey.currentState;
    if (currentState == null) return;

    final isValid = currentState.validate(focusOnInvalid: false);

    final usernameValue = currentState.fields['username']?.value;
    final emailValue = currentState.fields['email']?.value;
    final passwordValue = currentState.fields['password']?.value;
    final passwordConfirmValue = currentState.fields['password_confirm']?.value;

    final allFilled = usernameValue.isNotEmpty && emailValue.isNotEmpty && passwordValue.isNotEmpty && passwordConfirmValue.isNotEmpty;

    setState(() {
      _isRegistrationDisabled = !(isValid && allFilled);
    });
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey[850],
        appBar: _buildAppbar(),
        body: _buildBody(),
      ),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  PreferredSizeWidget _buildAppbar() {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(l10n.registration),
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
    return FormBuilder(
      key: _formKey,
      onChanged: _checkRegistrationFieldsValidation,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //a kulcs paraméterek a teszteléshez kellenek!
                  _buildUsernameWidget(const Key("userName")),
                  _buildEmailWidget(const Key("emailAddress")),
                  _buildPasswordWidget(const Key("passWord")),
                  _buildPasswordConfirmWidget(const Key("passWordConfirm")),
                  _buildSignupWidget(context, const Key("signUp")),
                ],
              ),
            ),
          ),
          _chatexWidget(),
        ],
      ),
    );
  }

  InputDecoration _decorationForInput(
    TextEditingController controller,
    String title,
    bool focusVariable,
    String? helperText, {
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
      helperText: helperText,
      helperStyle: const TextStyle(
        color: Colors.white,
        fontSize: 15.0,
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

  Widget _buildUsernameWidget(Key key) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 10.0),
      child: FormBuilderTextField(
        name: "username",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.minLength(
            usernameMinLength,
            errorText: l10n.usernameTooShort,
            checkNullOrEmpty: false,
          ),
          FormBuilderValidators.maxLength(
            usernameMaxLength,
            errorText: l10n.usernameTooLong,
            checkNullOrEmpty: false,
          ),
        ]),
        focusNode: _usernameFocusNode,
        controller: _usernameController,
        keyboardType: TextInputType.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: _decorationForInput(
          _usernameController,
          l10n.username,
          _isUsernameFocused,
          null,
        ),
      ),
    );
  }

  Widget _buildEmailWidget(Key key) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: FormBuilderTextField(
        name: "email",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.email(
              regex: RegExp(emailValidationRegex, unicode: true), errorText: l10n.emailAddressInvalid, checkNullOrEmpty: false),
        ]),
        focusNode: _emailFocusNode,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: _decorationForInput(
          _emailController,
          l10n.emailAddress,
          _isEmailFocused,
          l10n.emailAddressHelp,
        ),
      ),
    );
  }

  Widget _buildPasswordWidget(Key key) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: FormBuilderTextField(
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
          l10n.passwordRequirements,
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

  Widget _buildPasswordConfirmWidget(Key key) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 30),
      child: FormBuilderTextField(
        name: "password_confirm",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.equal(_passwordController.text, errorText: l10n.passwordsDoesntMatch, checkNullOrEmpty: false),
        ]),
        focusNode: _passwordConfirmFocusNode,
        controller: _passwordConfirmController,
        obscureText: _isPasswordConfirmNotVisible,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: _decorationForInput(
          _passwordConfirmController,
          l10n.confirmPassword,
          _isPasswordConfirmFocused,
          null,
          onVisibilityToggle: () {
            setState(() {
              _isPasswordConfirmNotVisible = !_isPasswordConfirmNotVisible;
            });
          },
          obscureText: _isPasswordConfirmNotVisible,
        ),
      ),
    );
  }

  Widget _buildSignupWidget(BuildContext context, Key key) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          //teljes szélességben legyen
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[700],
                disabledForegroundColor: Colors.white,
                elevation: 5,
              ),
              onPressed: _isRegistrationDisabled
                  ? null
                  : () async {
                      _onRegisterButtonPressed(
                          _usernameController.text.trim(), _emailController.text.trim(), _passwordController.text.trim(), widget.language);
                      //ha megnyomódott akkor lépjen ki a billentyűzetből
                      // FocusScope.of(context).unfocus();
                      // if (_formKey.currentState!.saveAndValidate()) {
                      //   // await AuthService().register(
                      //   //   username: _usernameController,
                      //   //   email: _emailController,
                      //   //   password: _passwordController,
                      //   //   context: context,
                      //   //   language: widget.language,
                      //   // );
                      //   _onRegisterButtonPressed(
                      //       _usernameController.text.trim(), _emailController.text.trim(), _passwordController.text.trim(), widget.language);
                      // }
                    },
              child: Text(
                l10n.registrationButton,
                style: TextStyle(
                  //minden kijelzőn egységes 20-as méret
                  fontSize: 20 * MediaQuery.of(context).textScaler.scale(1.0),
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

  void _onRegisterButtonPressed(String username, String email, String password, String language) async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.saveAndValidate()) {
      final authService = AuthService();
      final l10n = AppLocalizations.of(context)!;

      try {
        //TODO: UI várakozik, amíg a logika dolgozik (pl. tehetsz ide egy töltőképernyőt)
        await authService.register(username: username, email: email, password: password, language: language);

        if (context.mounted) {
          ToastMessages.showToastMessages(
              l10n.successfulRegistration, 0.2, Colors.green, Icons.check, Colors.black, const Duration(seconds: 2), context);
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginUI()));
        }
      } catch (e) {
        if (context.mounted) {
          String errorMessage = l10n.error;
          if (e.toString().contains('email_already_used')) {
            errorMessage = l10n.emailAddressAlreadyUsed;
          } else if (e.toString().contains('registration_failed')) {
            errorMessage = l10n.connectionErrorRegistration;
          } else if (e.toString().contains('connection_error')) {
            errorMessage = l10n.connectionErrorLogin;
          }
          ToastMessages.showToastMessages(errorMessage, 0.2, Colors.redAccent, Icons.error, Colors.black, const Duration(seconds: 2), context);
        }
      }
    }
  }

  Widget _chatexWidget() {
    return const Expanded(
      flex: 0,
      child: Row(
        children: [
          Expanded(
            //teljes szélességben legyen
            flex: 1,
            child: Padding(
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
            ),
          ),
        ],
      ),
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//SignUp OSZTÁLY VÉGE -----------------------------------------------------------------------------
