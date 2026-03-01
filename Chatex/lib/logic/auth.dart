import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chatex/application/components_of_chat/build_ui.dart';
import 'package:chatex/main.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
import 'dart:developer';
import 'dart:convert';

//AuthService OSZTÁLY ELEJE -----------------------------------------------------------------------

class AuthService {
//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------
  //ez a metódus felel azért hogy a felhasználó regisztrálni tudjon a Chatex-be
  Future<void> register({
    required TextEditingController username,
    required TextEditingController email,
    required TextEditingController password,
    required BuildContext context,
    required String
        language, //eltároljuk a nyelvet, de megfelelő nyelven küldjük a választ is!
  }) async {
    try {
      //eltároljuk a regisztrációkor megszerzett adatokat és továbbítjuk az adatbázisnak
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2/ChatexProject/chatex_phps/auth/register.php'),
        body: jsonEncode(<String, String>{
          'username': username.text.trim(),
          'email': email.text.trim(),
          'password': password.text.trim(),
          'language': language,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData["message"] == "Sikeres regisztráció!") {
        //a regisztráció után egyedül a preferált nyelvet állítjuk be, mivel valószínű hogy a felhasználó be is akar lépni!
        final preferredlang = responseData['preferred_lang'];

        await Preferences.setPreferredLanguage(preferredlang);

        ToastMessages.showToastMessages(
          language == "Magyar"
              ? "Sikeres regisztráció!"
              : "Successful registration!",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
        await Future.delayed(const Duration(seconds: 2));
        //és fontos hogy a nyelvén legyen a bejelentkezési felület
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginUI(),
          ),
        );
      } else if (responseData["message"] ==
          "Ezzel az emailel már létezik felhasználó!") {
        //lekezeljük ha már létezik ilyen email-el felhasználó!
        ToastMessages.showToastMessages(
          language == "Magyar"
              ? "Ezzel az emailel már létezik felhasználó!"
              : "User already exists with this email!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      } else if (responseData["message"] == "Érvénytelen email cím!") {
        //vagy hogy érvénytelen e az email cím
        ToastMessages.showToastMessages(
          language == "Magyar"
              ? "Érvénytelen email cím!"
              : "Invalid email address!",
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
            ? "Kapcsolati hiba a\nregisztráció közben!"
            : "Connection error while\nregistration!",
        0.2,
        Colors.redAccent,
        Icons.error_rounded,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Kapcsolati hiba a regisztráció közben! ${e.toString()}");
    }
  }

  //ez a metódus felel a regisztált felhasználók beléptetéséért!
  Future<void> logIn({
    required TextEditingController email,
    required TextEditingController password,
    required BuildContext context,
    required String
        language, //eltároljuk a nyelvet, de megfelelő nyelven küldjük a választ is!
  }) async {
    try {
      //a kiválasztott nyelvet, email-t, és jelszót is elmentjük és frissítjük az adatbázisban, illetve...
      final response = await http.post(
        Uri.parse('http://10.0.2.2/ChatexProject/chatex_phps/auth/login.php'),
        body: jsonEncode(<String, String>{
          'email': email.text.trim(),
          'password': password.text.trim(),
        }),
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        //a Preferences osztályba is felvesszük az értékeket,
        //mivel ha a felhasználó újra lép az alkalmazásba akkor ne keljen újra bejelentkeznie!
        final userId = responseData['id'];
        final preferredlang = responseData['preferred_lang'];
        final profilePicture = responseData['profile_picture'];
        final username = responseData['username'];
        final email = responseData['email'];
        final passwordHash = responseData['password_hash'];
        final token = responseData['token'];
        final status = responseData['status'];

        await Preferences.setUserId(userId);
        await Preferences.setPreferredLanguage(preferredlang);
        await Preferences.setProfilePicture(profilePicture);
        await Preferences.setUsername(username);
        await Preferences.setEmail(email);
        //a PasswordHash-t végül nem használtuk, de a közel jövőben hasznos lehet!
        await Preferences.setPasswordHash(passwordHash);
        //token alapján működik a bejelentkezve maradás (ami 24 óráig tart)
        await Preferences.setToken(token);
        await Preferences.setStatus(status);
        ToastMessages.showToastMessages(
          language == "Magyar" ? "Sikeres bejelentkezés!" : "Successful login!",
          0.22,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );

        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          //belépés utáni képernyő
          context,
          MaterialPageRoute(
            builder: (context) => const ChatUI(),
          ),
        );
      } else if (responseData['message'] == 'Hibás email vagy jelszó!') {
        //ha nem létezik ilyen adatokkal felhasználó!
        ToastMessages.showToastMessages(
          language == "Magyar"
              ? "Hibás email vagy jelszó!"
              : "Incorrect email or password!",
          0.22,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      } else {
        //ha más hiba történt megmondja a hibakódot amivel már tájékoztathatja a fejlesztőket!
        ToastMessages.showToastMessages(
          language == "Magyar"
              ? "Hiba kód: ${response.statusCode}"
              : "Error code: ${response.statusCode}",
          0.22,
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
            ? "Kapcsolati hiba a\nbejelentkezés közben!"
            : "Connection error while\nlogging in!",
        0.22,
        Colors.redAccent,
        Icons.error_rounded,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Kapcsolati hiba a bejelentkezés közben! ${e.toString()}");
    }
  }

  //ez a metódus felel a felhasználó kijelentkeztetéséért
  Future<void> logOut({required BuildContext context}) async {
    final userId = Preferences.getUserId();

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/ChatexProject/chatex_phps/auth/logout.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );

      final responseData = json.decode(response.body);

      if (responseData["success"] == true) {
        //ha sikeres volt a kijelentkeztetés,
        //akkor töröljük az elmentett adatokat és visszadobjuk a felhasználót a bejelentkezési képernyőre
        //az adatbázisban pedig az signed_in mezőt 0-ra frissítjük -> offline állapotban fog megjelenni más felhasználóknak
        await Future.delayed(const Duration(seconds: 2));
        await Preferences.clearPreferences();
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginUI()),
          );
        }
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a\nkijelentkezés közben!"
            : "Connection error while\nlogging out!",
        0.2,
        Colors.redAccent,
        Icons.error_rounded,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Kapcsolati hiba a kijelentkezés közben! ${e.toString()}");
    }
  }

  //ez a metódus felel a jelszó helyreállításáért ha a felhasználó elfelejtett volna jelszavát!
  Future<void> resetPassword(
      {required TextEditingController email,
      required BuildContext context,
      required language}) async {
    try {
      //mivel a főképernyőről megyünk a helyreállító oldalra ezért bekérjük a nyelvet (megfelelő válasz)
      //és az emailt amihez küldeni fogjuk a helyreállító emailt!
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2/ChatexProject/chatex_phps/reset_password/reset_password.php'),
        body: jsonEncode(<String, String>{
          'email': email.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData["message"] == "Helyreállító e-mail elküldve.") {
        ToastMessages.showToastMessages(
          language == "Magyar"
              ? "A jelszó helyreállító emailt elküldtük!"
              : "Password recovery email sent!",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
        await Future.delayed(const Duration(seconds: 2));
        //visszadobjuk a felhasználót a bejelentkezési oldalra!
        Navigator.pop(context);
      } else if (responseData["message"] ==
          "Nincs ilyen email című felhasználó!") {
        ToastMessages.showToastMessages(
          language == "Magyar"
              ? "Nincs ilyen email című felhasználó!"
              : "No user with this email address!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      } else {
        //megmondjuk a felhasználónak a hibakódot!
        ToastMessages.showToastMessages(
          language == "Magyar"
              ? "Hiba kód: ${response.statusCode}"
              : "Error code: ${response.statusCode}",
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
            ? "Kapcsolati hiba a\njelszó helyreállításánál!"
            : "Connection error while\nresetting password!",
        0.2,
        Colors.redAccent,
        Icons.error_rounded,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Kapcsolati hiba a jelszóhelyreállító email küldése közben! ${e.toString()}");
    }
  }
//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------
}

//AuthService OSZTÁLY VÉGE ------------------------------------------------------------------------
