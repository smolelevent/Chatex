import 'package:chatex/core/local_storage/preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chatex/core/constants/api_constants.dart';
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
    try {
      final existingUser = await supabase.from('users').select('username').eq('username', username).maybeSingle();

      if (existingUser != null) {
        throw Exception('email_already_used');
      }

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
          'status': 'offline',
          'signed_in': false,
        });

        await Preferences.setPreferredLanguage(language);
      } else {
        throw Exception('registration_failed');
      }
    } on AuthException catch (e) {
      //TODO: ha egyáltalán ezt adja e
      log("Auth hiba: ${e.message}");
    } catch (e) {
      log("Kapcsolati hiba a bejelentkezés közben! ${e.toString()}");
      throw Exception('connection_error');
    }
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final User? user = response.user;

      if (user != null) {
        final userData = await supabase.from('users').select().eq('email', user.email!).single();

        await Preferences.setPreferredLanguage(userData['preferred_lang']);
        await Preferences.setUserId(userData['id']);
        await Preferences.setProfilePicture(userData['profile_picture'] ?? '');
        await Preferences.setUsername(userData['username']);
        await Preferences.setEmail(userData['email']);
        await Preferences.setStatus('online');

        // TODO: A token és password_hash kezelését a Supabase automatikusan végzi a háttérben,
        // így azokat már nem kell manuálisan a Preferences-be menteni!

        await supabase.from('users').update({'signed_in': true, 'status': 'online'}).eq('email', user.email!);
      } else {
        //TODO: nincs lekezelve
        throw Exception('auth_failed');
      }
    } on AuthException catch (e) {
      log("Auth hiba: ${e.message}");
      throw Exception('invalid_credentials');
    } catch (e) {
      log("Kapcsolati hiba a bejelentkezés közben! ${e.toString()}");
      throw Exception('connection_error');
    }
  }

  Future<void> logOut() async {
    try {
      final userId = Preferences.getUserId();

      if (userId != null) {
        await supabase
            .from('users')
            .update({'signed_in': false, 'status': 'offline', 'last_seen': DateTime.now().toIso8601String()}).eq('id', userId);
      }

      await supabase.auth.signOut();

      await Preferences.clearPreferences();
    } catch (e) {
      log("Kijelentkezési hiba: $e");
      throw Exception('logout_error');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      // A Supabase automatikusan elküldi a jelszó-visszaállító linket
      await supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      log("Supabase jelszó-visszaállítási hiba: ${e.message}");
      throw Exception('reset_error');
    } catch (e) {
      log("Kapcsolati hiba a jelszó-visszaállításnál: $e");
      throw Exception('connection_error');
    }
  }

  Future<bool> tryAutoLoginByToken() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      // Ha a user nem null, az azt jelenti, hogy a Supabase talált egy érvényes
      // session-t (tokent) a telefonon, tehát a felhasználó be van jelentkezve.
      if (user != null) {
        // Lekérjük a felhasználó legfrissebb adatait a TE adatbázisodból
        final userData = await supabase.from('users').select().eq('email', user.email!).single();

        await Preferences.setUserId(userData['id']);
        await Preferences.setPreferredLanguage(userData['preferred_lang']);
        await Preferences.setProfilePicture(userData['profile_picture'] ?? '');
        await Preferences.setUsername(userData['username']);
        await Preferences.setEmail(userData['email']);
        await Preferences.setStatus('online');

        // Frissítjük az állapotot az adatbázisban, hogy mások lássák: online van
        await supabase.from('users').update({'signed_in': true, 'status': 'online'}).eq('email', user.email!);

        return true; // Sikeres automatikus bejelentkezés, mehet a ChatUI-ra!
      }
    } catch (e) {
      log("Hiba az automatikus bejelentkezés során: ${e.toString()}");
    }

    // Ha nincs bejelentkezve, vagy hiba történt, biztonságból töröljük a helyi adatokat
    await Preferences.clearPreferences();
    return false; // Vissza a LoginUI-ra
  }
//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------
}

//AuthService OSZTÁLY VÉGE ------------------------------------------------------------------------
