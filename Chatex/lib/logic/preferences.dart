import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Preferences OSZTÁLY ELEJE -----------------------------------------------------------------------

class Preferences {
//OSZTÁLY VÁLTOZÓK ELEJE --------------------------------------------------------------------------

  static SharedPreferences? _prefs; //SharedPreferences osztály példánya

  //ez a változó a nyelv változását figyeli, és ha eltér a "Magyar"-tól akkor lefrissíti a többi Dart-ban a nyelvet
  static ValueNotifier<String> languageNotifier = ValueNotifier<String>("Magyar");

//OSZTÁLY VÁLTOZÓK VÉGE ---------------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  //inicializálás (ezt a main.dart-ban egyszer kell meghívni)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //Setterek ELEJE --------------------------------------------------------------------------------
  //ezekkel a metódusokkal tároljuk el pl.: bejelentkezéskor az adatokat amit később is használatba tudunk venni!

  static Future<void> setUserId(int id) async {
    await _prefs?.setInt('id', id);
  }

  static Future<void> setPreferredLanguage(String language) async {
    await _prefs?.setString('preferred_lang', language);
    languageNotifier.value = language;
  }

  static Future<void> setProfilePicture(String profilePicture) async {
    await _prefs?.setString('profile_picture', profilePicture);
  }

  static Future<void> setUsername(String username) async {
    await _prefs?.setString('username', username);
  }

  static Future<void> setEmail(String email) async {
    await _prefs?.setString('email', email);
  }

  static Future<void> setPasswordHash(String passwordHash) async {
    await _prefs?.setString('password_hash', passwordHash);
  }

  static Future<void> setStatus(String status) async {
    await _prefs?.setString("status", status);
  }

  //Setterek VÉGE ---------------------------------------------------------------------------------

  //Getterek ELEJE --------------------------------------------------------------------------------
  //ezek a metódusok pedig az értékek lekérésére vannak (leggyakrabban ezeket használtuk!)

  static int? getUserId() {
    return _prefs?.getInt('id');
  }

  static String getPreferredLanguage() {
    Future.microtask(() {
      //a Future.microtask szükséges, mivel exceptiont ad ha túl gyorsan kerülnek betöltésre (még nincs értéke)
      languageNotifier.value = _prefs?.getString('preferred_lang') ?? 'Magyar';
    });
    return _prefs?.getString('preferred_lang') ?? 'Magyar'; //alapértelmezett a Magyar
  }

  static String? getProfilePicture() {
    return _prefs?.getString('profile_picture');
  }

  static String getUsername() {
    return _prefs?.getString('username') ?? '';
  }

  static String? getEmail() {
    return _prefs?.getString('email');
  }

  static String? getPasswordHash() {
    return _prefs?.getString('password_hash');
  }

  static String? getStatus() {
    //alapértelmezett státusz az offline (nem elérhető a felhasználó)
    return _prefs?.getString('status') ?? 'offline';
  }

  //Getterek VÉGE ---------------------------------------------------------------------------------

  //EGYÉB METÓDUSOK ELEJE -------------------------------------------------------------------------

  static Future<void> clearPreferences() async {
    //ez a metódus törli az összes key-value párt lokálisan (csak kijelentkezéskor fut le!)
    await _prefs?.clear();
  }

  //EGYSZERŰSÍTŐ METÓDUS(OK) (gyakran használt(ak)) -----------------------------------------------

  //lerövidűl a kód hossz ha ezt használom pl.: Preferences.isHungarian ? ... : ...
  //mint ha ezt használnám: Preferences.getPreferredLanguage() == "Magyar" ? ... : ...
  static bool get isHungarian => getPreferredLanguage() == "Magyar";

  //EGYÉB METÓDUSOK VÉGE --------------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------
}

//Preferences OSZTÁLY VÉGE ------------------------------------------------------------------------
