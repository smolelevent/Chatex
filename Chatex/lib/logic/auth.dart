import 'package:flutter/material.dart';
import 'package:chatex/application/components_of_chat/build_ui.dart';
import 'package:chatex/main.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chatex/constants/api_constants.dart';
import 'dart:developer';

//AuthService OSZTÁLY ELEJE -----------------------------------------------------------------------

class AuthService {
//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------
  Future<void> register({
    required TextEditingController username,
    required TextEditingController email,
    required TextEditingController password,
    required BuildContext context,
    required String language,
  }) async {
    try {
      final String inputUsername = username.text.trim();
      final String inputEmail = email.text.trim();

      // 1. Ellenőrizzük, hogy a felhasználónév foglalt-e a TE tábládban
      final existingUser = await supabase.from('users').select('username').eq('username', inputUsername).maybeSingle();

      if (existingUser != null) {
        if (context.mounted) {
          ToastMessages.showToastMessages(
            language == "Magyar" ? "Foglalt felhasználónév!" : "Username is already taken!",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2),
            context,
          );
        }
        return;
      }

      // 2. Supabase Auth Regisztráció (Ez ellenőrzi, hogy az email foglalt-e)
      final AuthResponse res = await supabase.auth.signUp(
        email: inputEmail,
        password: password.text.trim(),
      );

      if (res.user != null) {
        await supabase.from('users').insert({
          'username': inputUsername,
          'email': inputEmail,
          'preferred_lang': language,
          'status': 'online',
          'signed_in': true,
        });

        // 4. Nyelv beállítása helyileg
        await Preferences.setPreferredLanguage(language);

        if (context.mounted) {
          ToastMessages.showToastMessages(
            language == "Magyar" ? "Sikeres regisztráció!" : "Successful registration!",
            0.2,
            Colors.green,
            Icons.check,
            Colors.black,
            const Duration(seconds: 2),
            context,
          );
          await Future.delayed(const Duration(seconds: 2));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginUI()),
          );
        }
      }
    } on AuthException catch (e) {
      // Ha a Supabase szerint az email már létezik vagy érvénytelen
      if (context.mounted) {
        String errorMsg = language == "Magyar" ? "Hiba a regisztrációkor!" : "Registration error!";
        if (e.message.contains('already registered')) {
          errorMsg = language == "Magyar"
              ? "Ezzel az e-maillel már létezik felhasználó!"
              : "User already exists with this email!";
        } else if (e.message.contains('invalid email')) {
          errorMsg = language == "Magyar" ? "Érvénytelen e-mail cím!" : "Invalid email address!";
        }

        ToastMessages.showToastMessages(
          errorMsg,
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      }
      log("Auth regisztrációs hiba: ${e.message}");
    } catch (e) {
      if (context.mounted) {
        ToastMessages.showToastMessages(
          language == "Magyar" ? "Kapcsolati hiba a\nregisztráció közben!" : "Connection error while\nregistration!",
          0.2,
          Colors.redAccent,
          Icons.error_rounded,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      }
      log("Általános hiba a regisztráció közben! ${e.toString()}");
    }
  }

  //     if (responseData["message"] == "Sikeres regisztráció!") {
  //       //a regisztráció után egyedül a preferált nyelvet állítjuk be, mivel valószínű hogy a felhasználó be is akar lépni!
  //       final preferredlang = responseData['preferred_lang'];
  //
  //       await Preferences.setPreferredLanguage(preferredlang);
  //
  //       ToastMessages.showToastMessages(
  //         language == "Magyar" ? "Sikeres regisztráció!" : "Successful registration!",
  //         0.2,
  //         Colors.green,
  //         Icons.check,
  //         Colors.black,
  //         const Duration(seconds: 2),
  //         context,
  //       );
  //       await Future.delayed(const Duration(seconds: 2));
  //       //és fontos hogy a nyelvén legyen a bejelentkezési felület
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const LoginUI(),
  //         ),
  //       );
  //     } else if (responseData["message"] == "Ezzel az emailel már létezik felhasználó!") {
  //       //lekezeljük ha már létezik ilyen email-el felhasználó!
  //       ToastMessages.showToastMessages(
  //         language == "Magyar" ? "Ezzel az emailel már létezik felhasználó!" : "User already exists with this email!",
  //         0.2,
  //         Colors.redAccent,
  //         Icons.error,
  //         Colors.black,
  //         const Duration(seconds: 2),
  //         context,
  //       );
  //     } else if (responseData["message"] == "Érvénytelen email cím!") {
  //       //vagy hogy érvénytelen e az email cím
  //       ToastMessages.showToastMessages(
  //         language == "Magyar" ? "Érvénytelen email cím!" : "Invalid email address!",
  //         0.2,
  //         Colors.redAccent,
  //         Icons.error,
  //         Colors.black,
  //         const Duration(seconds: 2),
  //         context,
  //       );
  //     }
  //   } catch (e) {
  //     ToastMessages.showToastMessages(
  //       Preferences.isHungarian ? "Kapcsolati hiba a\nregisztráció közben!" : "Connection error while\nregistration!",
  //       0.2,
  //       Colors.redAccent,
  //       Icons.error_rounded,
  //       Colors.black,
  //       const Duration(seconds: 3),
  //       context,
  //     );
  //     log("Kapcsolati hiba a regisztráció közben! ${e.toString()}");
  //   }
  // }

  Future<void> logIn({
    required TextEditingController email,
    required TextEditingController password,
    required BuildContext context,
    required String language,
  }) async {
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      final User? user = response.user;

      if (user != null) {
        // 2. Lekérjük a felhasználó extra adatait a TE 'users' tábládból
        final userData = await supabase.from('users').select().eq('email', user.email!).single();

        // 3. Eltároljuk az adatokat a Preferences-ben (ahogy eddig is)

        await Preferences.setPreferredLanguage(userData['preferred_lang']);
        await Preferences.setUserId(userData['id']);
        await Preferences.setProfilePicture(userData['profile_picture'] ?? '');
        await Preferences.setUsername(userData['username']);
        await Preferences.setEmail(userData['email']);
        await Preferences.setStatus('online');

        // TODO: A token és password_hash kezelését a Supabase automatikusan végzi a háttérben,
        // így azokat már nem kell manuálisan a Preferences-be menteni!

        // 4. Státusz frissítése az adatbázisban (signed_in = true)
        await supabase.from('users').update({'signed_in': true, 'status': 'online'}).eq('email', user.email!);

        if (context.mounted) {
          ToastMessages.showToastMessages(
            //TODO: l10n átírni
            language == "Magyar" ? "Sikeres bejelentkezés!" : "Successful login!",
            0.22, Colors.green, Icons.check, Colors.black, const Duration(seconds: 2), context,
          );
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ChatUI()),
          );
        }
      }
    } on AuthException catch (e) {
      // A Supabase maga mondja meg, ha rossz a jelszó
      if (context.mounted) {
        //TODO: összes lehetőséget lekezelni
        ToastMessages.showToastMessages(
          language == "Magyar" ? "Hibás email vagy jelszó!" : "Incorrect email or password!",
          0.22,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      }
      log("Auth hiba: ${e.message}");
    } catch (e) {
      if (context.mounted) {
        ToastMessages.showToastMessages(
          language == "Magyar" ? "Kapcsolati hiba!" : "Connection error!",
          0.22,
          Colors.redAccent,
          Icons.error_rounded,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      }
      log("Általános hiba a bejelentkezés közben! ${e.toString()}");
    }
    // try {
    //   //a kiválasztott nyelvet, email-t, és jelszót is elmentjük és frissítjük az adatbázisban, illetve...
    //   final response = await http.post(
    //     Uri.parse(loginUrl),
    //     body: jsonEncode(<String, String>{
    //       'email': email.text.trim(),
    //       'password': password.text.trim(),
    //     }),
    //   );
    //
    //   final responseData = json.decode(response.body);
    //
    //   if (responseData['success'] == true) {
    //     //a Preferences osztályba is felvesszük az értékeket,
    //     //mivel ha a felhasználó újra lép az alkalmazásba akkor ne keljen újra bejelentkeznie!
    //     final userId = responseData['id'];
    //     final preferredlang = responseData['preferred_lang'];
    //     final profilePicture = responseData['profile_picture'];
    //     final username = responseData['username'];
    //     final email = responseData['email'];
    //     final passwordHash = responseData['password_hash'];
    //     final token = responseData['token'];
    //     final status = responseData['status'];
    //
    //     await Preferences.setUserId(userId);
    //     await Preferences.setPreferredLanguage(preferredlang);
    //     await Preferences.setProfilePicture(profilePicture);
    //     await Preferences.setUsername(username);
    //     await Preferences.setEmail(email);
    //     //a PasswordHash-t végül nem használtuk, de a közel jövőben hasznos lehet!
    //     await Preferences.setPasswordHash(passwordHash);
    //     //token alapján működik a bejelentkezve maradás (ami 24 óráig tart)
    //     await Preferences.setToken(token);
    //     await Preferences.setStatus(status);
    //     ToastMessages.showToastMessages(
    //       language == "Magyar" ? "Sikeres bejelentkezés!" : "Successful login!",
    //       0.22,
    //       Colors.green,
    //       Icons.check,
    //       Colors.black,
    //       const Duration(seconds: 2),
    //       context,
    //     );
    //
    //     await Future.delayed(const Duration(seconds: 2));
    //     Navigator.pushReplacement(
    //       //belépés utáni képernyő
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => const ChatUI(),
    //       ),
    //     );
    //   } else if (responseData['message'] == 'Hibás email vagy jelszó!') {
    //     //ha nem létezik ilyen adatokkal felhasználó!
    //     ToastMessages.showToastMessages(
    //       language == "Magyar" ? "Hibás email vagy jelszó!" : "Incorrect email or password!",
    //       0.22,
    //       Colors.redAccent,
    //       Icons.error,
    //       Colors.black,
    //       const Duration(seconds: 2),
    //       context,
    //     );
    //   } else {
    //     //ha más hiba történt megmondja a hibakódot amivel már tájékoztathatja a fejlesztőket!
    //     ToastMessages.showToastMessages(
    //       language == "Magyar" ? "Hiba kód: ${response.statusCode}" : "Error code: ${response.statusCode}",
    //       0.22,
    //       Colors.redAccent,
    //       Icons.error,
    //       Colors.black,
    //       const Duration(seconds: 2),
    //       context,
    //     );
    //   }
    // } catch (e) {
    //   ToastMessages.showToastMessages(
    //     Preferences.isHungarian ? "Kapcsolati hiba a\nbejelentkezés közben!" : "Connection error while\nlogging in!",
    //     0.22,
    //     Colors.redAccent,
    //     Icons.error_rounded,
    //     Colors.black,
    //     const Duration(seconds: 3),
    //     context,
    //   );
    //   log("Kapcsolati hiba a bejelentkezés közben! ${e.toString()}");
    // }
  }

  Future<void> logOut({required BuildContext context}) async {
    try {
      final userId = Preferences.getUserId();

      // 1. Átállítjuk a státuszt a te tábládban offline-ra
      if (userId != null) {
        await supabase.from('users').update(
            {'signed_in': false, 'status': 'offline', 'last_seen': DateTime.now().toIso8601String()}).eq('id', userId);
      }

      // 2. Kijelentkeztetés a Supabase Auth-ból
      await supabase.auth.signOut();

      await Future.delayed(const Duration(seconds: 2));
      // 3. Töröljük a helyi adatokat
      await Preferences.clearPreferences();

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginUI()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ToastMessages.showToastMessages(
          Preferences.isHungarian ? "Hiba a kijelentkezésnél!" : "Error logging out!",
          0.2,
          Colors.redAccent,
          Icons.error_rounded,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      }
      log("Hiba a kijelentkezés közben! ${e.toString()}");
    }
  }

  // final response = await http.post(
  //   Uri.parse(logoutUrl),
  //   headers: {"Content-Type": "application/json"},
  //   body: jsonEncode({"user_id": userId}),
  // );

  // final responseData = json.decode(response.body);

  //   if (responseData["success"] == true) {
  //     //ha sikeres volt a kijelentkeztetés,
  //     //akkor töröljük az elmentett adatokat és visszadobjuk a felhasználót a bejelentkezési képernyőre
  //     //az adatbázisban pedig az signed_in mezőt 0-ra frissítjük -> offline állapotban fog megjelenni más felhasználóknak
  //     await Future.delayed(const Duration(seconds: 2));
  //     await Preferences.clearPreferences();
  //     if (context.mounted) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const LoginUI()),
  //       );
  //     }
  //   }
  // } catch (e) {
  //   ToastMessages.showToastMessages(
  //     Preferences.isHungarian ? "Kapcsolati hiba a\nkijelentkezés közben!" : "Connection error while\nlogging out!",
  //     0.2,
  //     Colors.redAccent,
  //     Icons.error_rounded,
  //     Colors.black,
  //     const Duration(seconds: 3),
  //     context,
  //   );
  //   log("Kapcsolati hiba a kijelentkezés közben! ${e.toString()}");
  // }

  Future<void> resetPassword(
      {required TextEditingController email, required BuildContext context, required language}) async {
    try {
      final String inputEmail = email.text.trim();

      // A Supabase automatikusan elküldi a jelszó-visszaállító linket
      await supabase.auth.resetPasswordForEmail(inputEmail);

      if (context.mounted) {
        ToastMessages.showToastMessages(
          language == "Magyar" ? "A jelszó helyreállító emailt elküldtük!" : "Password recovery email sent!",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );

        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context);
      }
    } on AuthException catch (e) {
      // Ha a Supabase hibát dob (pl. túl sok kérés)
      if (context.mounted) {
        ToastMessages.showToastMessages(
          language == "Magyar" ? "Hiba történt a küldés során!" : "Error sending email!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      }
      log("Auth jelszó-visszaállítási hiba: ${e.message}");
    } catch (e) {
      if (context.mounted) {
        ToastMessages.showToastMessages(
          language == "Magyar"
              ? "Kapcsolati hiba a\njelszó helyreállításánál!"
              : "Connection error while\nresetting password!",
          0.2,
          Colors.redAccent,
          Icons.error_rounded,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      }
      log("Kapcsolati hiba a jelszóhelyreállító email küldése közben! ${e.toString()}");
    }
  }
  // try {
  //   //mivel a főképernyőről megyünk a helyreállító oldalra ezért bekérjük a nyelvet (megfelelő válasz)
  //   //és az emailt amihez küldeni fogjuk a helyreállító emailt!
  //   final response = await http.post(
  //     Uri.parse(resetPasswordUrl),
  //     body: jsonEncode(<String, String>{
  //       'email': email.text.trim(),
  //     }),
  //   );
  //
  //   final responseData = jsonDecode(response.body);
  //
  //   if (responseData["message"] == "Helyreállító e-mail elküldve.") {
  //     ToastMessages.showToastMessages(
  //       language == "Magyar" ? "A jelszó helyreállító emailt elküldtük!" : "Password recovery email sent!",
  //       0.2,
  //       Colors.green,
  //       Icons.check,
  //       Colors.black,
  //       const Duration(seconds: 2),
  //       context,
  //     );
  //     await Future.delayed(const Duration(seconds: 2));
  //     //visszadobjuk a felhasználót a bejelentkezési oldalra!
  //     Navigator.pop(context);
  //   } else if (responseData["message"] == "Nincs ilyen email című felhasználó!") {
  //     ToastMessages.showToastMessages(
  //       language == "Magyar" ? "Nincs ilyen email című felhasználó!" : "No user with this email address!",
  //       0.2,
  //       Colors.redAccent,
  //       Icons.error,
  //       Colors.black,
  //       const Duration(seconds: 2),
  //       context,
  //     );
  //   } else {
  //     //megmondjuk a felhasználónak a hibakódot!
  //     ToastMessages.showToastMessages(
  //       language == "Magyar" ? "Hiba kód: ${response.statusCode}" : "Error code: ${response.statusCode}",
  //       0.2,
  //       Colors.redAccent,
  //       Icons.error,
  //       Colors.black,
  //       const Duration(seconds: 2),
  //       context,
  //     );
  //   }
  // } catch (e) {
  //   ToastMessages.showToastMessages(
  //     Preferences.isHungarian
  //         ? "Kapcsolati hiba a\njelszó helyreállításánál!"
  //         : "Connection error while\nresetting password!",
  //     0.2,
  //     Colors.redAccent,
  //     Icons.error_rounded,
  //     Colors.black,
  //     const Duration(seconds: 3),
  //     context,
  //   );
  //   log("Kapcsolati hiba a jelszóhelyreállító email küldése közben! ${e.toString()}");
  // }
  //}
//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------
}

//AuthService OSZTÁLY VÉGE ------------------------------------------------------------------------
