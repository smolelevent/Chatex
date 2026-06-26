import 'package:flutter/material.dart';
import 'package:chatex/features/home/presentation/screens/home_screen.dart';
import 'package:chatex/main.dart';
import 'package:chatex/core/utils/toast_message.dart';
import 'package:chatex/core/local_storage/preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chatex/core/constants/api_constants.dart';
import 'package:chatex/l10n/app_localizations.dart';
import 'dart:developer';

//AuthService OSZTÁLY ELEJE -----------------------------------------------------------------------

class AuthService {
//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String language,
  }) async {
    //final String inputUsername = username.text.trim();
    //final String inputEmail = email.text.trim();

    // 1. Ellenőrizzük, hogy a felhasználónév foglalt-e a TE tábládban
    final existingUser = await supabase.from('users').select('username').eq('username', username).maybeSingle();

    if (existingUser != null) {
      // Nem toasztolunk, hanem hibát dobunk, amit a UI majd elkap!
      throw Exception('email_already_used');
      // if (context.mounted) {
      //   ToastMessages.showToastMessages(
      //     language == "Magyar" ? "Foglalt felhasználónév!" : "Username is already taken!",
      //     0.2,
      //     Colors.redAccent,
      //     Icons.error,
      //     Colors.black,
      //     const Duration(seconds: 2),
      //     context,
      //   );
      // }
      //return;
    }

    // 2. Supabase Auth Regisztráció (Ez ellenőrzi, hogy az email foglalt-e)
    final AuthResponse res = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (res.user != null) {
      await supabase.from('users').insert({
        'username': username,
        'email': email,
        'password_hash': 'managed_by_supabase',
        'preferred_lang': language,
        'status': 'online',
        'signed_in': true,
      });

      // 4. Nyelv beállítása helyileg
      await Preferences.setPreferredLanguage(language);

      // if (context.mounted) {
      //   ToastMessages.showToastMessages(
      //     language == "Magyar" ? "Sikeres regisztráció!" : "Successful registration!",
      //     0.2,
      //     Colors.green,
      //     Icons.check,
      //     Colors.black,
      //     const Duration(seconds: 2),
      //     context,
      //   );
      //   await Future.delayed(const Duration(seconds: 2));
      //
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const LoginUI()),
      //   );
      // }
    }
  }

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
          //TODO: Keresd meg az összes olyan függvényt, ami HTTP/Supabase kérést indít el, és mozgass minden AppLocalizations.of(context)! hívást szigorúan az if (context.mounted) { ... } blokkok belsejébe! A build() metódusban (ami a UI-t rajzolja) nyugodtan maradhat a legtetején, mert ott már felépült a context.
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
        final l10n = AppLocalizations.of(context)!;
        ToastMessages.showToastMessages(
          l10n.connectionErrorLogout,
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
//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------
}

//AuthService OSZTÁLY VÉGE ------------------------------------------------------------------------
