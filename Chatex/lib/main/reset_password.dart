import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:chatex/logic/auth.dart';

//ForgotPasswordPage OSZTÁLY ELEJE ----------------------------------------------------------------
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, required this.language});

  //konstruktorba átadjuk hogy bejelentkezés előtt, módosított nyelvnél megfelelően jelenjenek meg a szövegek!
  final String language;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  //szokásos tartalom és fókusz kezelés
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isEmailFocused = false;

  //a helyreállító email küldésekor a várakozást true-ra állítjuk, amíg nem végez
  bool _isLoading = false;

  //main.dart-hoz hasonlóan kezeljük a validálást
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPasswordResetButtonDisabled = true;

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _checkPasswordResetFieldValidation() {
    //main.dart logikája szerint lett elkészítve, 1 mezővel
    final currentState = _formKey.currentState;
    if (currentState == null) return;

    final isValid = currentState.validate(focusOnInvalid: false);

    final emailValue = currentState.fields['email']?.value?.trim() ?? '';

    final isEmailFilled = emailValue.isNotEmpty;

    setState(() {
      _isPasswordResetButtonDisabled = !(isValid && isEmailFilled);
    });
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
      title: Text(
        widget.language == "Magyar" ? "Jelszó helyreállítás" : "Reset password",
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
    return Stack(
      //Stack widget-tel tudunk megjeleníteni töltő karikát a tartalom mellett
      children: [
        FormBuilder(
          key: _formKey,
          onChanged: () {
            _checkPasswordResetFieldValidation();
          },
          child: Column(
            children: [
              _buildInformationText(),
              _buildEmailWidget(),
              _buildPasswordResetButton(),
              _chatexWidget(),
            ],
          ),
        ),
        if (_isLoading) _buildLoadingCircle(),
      ],
    );
  }

  Widget _buildInformationText() {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 25),
      child: Text(
        widget.language == "Magyar"
            ? "A jelszó helyreállításához\nadja meg az e-mail címét!"
            : "To reset your password\nenter your email address!",
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildEmailWidget() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
      child: FormBuilderTextField(
        name: "email",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.email(
              regex: RegExp(
                  r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                  unicode: true),
              errorText: widget.language == "Magyar"
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
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          suffixIcon: _emailController.text.isNotEmpty
              ? _buildDeleteContentIcon()
              : null,
          hintText: _isEmailFocused
              ? null
              : widget.language == "Magyar"
                  ? "E-mail cím"
                  : "Email address",
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          labelText: _isEmailFocused
              ? widget.language == "Magyar"
                  ? "E-mail cím"
                  : "Email address"
              : null,
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
        ),
      ),
    );
  }

  Widget _buildDeleteContentIcon() {
    return GestureDetector(
      onTap: () => _emailController.clear(),
      child: const Icon(
        Icons.clear_rounded,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPasswordResetButton() {
    return Expanded(
      //flex: 0 azt csinálja hogy a Chatex felirathoz képest nem foglal el semmien arányt,
      //így csak annyit amennyire szüksége van!
      flex: 0,
      child: Row(
        children: [
          Expanded(
            //teljes szélességet érjen el
            flex: 1,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[700],
                  disabledForegroundColor: Colors.white,
                  elevation: 5,
                ),
                onPressed: _isPasswordResetButtonDisabled || _isLoading
                    //egyik sem true alapértelmezetten
                    ? null
                    : () async {
                        if (_formKey.currentState!.saveAndValidate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            await AuthService().resetPassword(
                              email: _emailController,
                              context: context,
                              language: widget.language,
                            );
                          } finally {
                            //a finally ág a műveletek végén fut le (amikor már nincs await)
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                child: Text(
                  widget.language == "Magyar"
                      ? "Jelszó helyreállítása"
                      : "Reset password",
                  style: TextStyle(
                    fontSize: 20 * MediaQuery.of(context).textScaler.scale(1.0),
                    //minden eszközön elvileg ugyanakkora lesz (px helyett dp)
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
    );
  }

  Widget _buildLoadingCircle() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: Colors.deepPurpleAccent,
      ),
    );
  }

  Widget _chatexWidget() {
    return const Expanded(
      //flex: 1-el a képernyő aljára helyezzük
      flex: 1,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Align(
          alignment: Alignment.bottomCenter,
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
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//ForgotPasswordPage OSZTÁLY VÉGE -----------------------------------------------------------------
