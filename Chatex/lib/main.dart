import 'package:chatex/core/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:chatex/l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:chatex/core/utils/locale_provider.dart';
import 'package:chatex/features/home/presentation/screens/home_screen.dart';
import 'package:chatex/features/notifications/data/notifications.dart';
import 'package:chatex/core/local_storage/preferences.dart';
import 'package:chatex/core/constants/language_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chatex/features/auth/presentation/screens/login_screen.dart';
import 'package:chatex/features/auth/data/auth.dart';

//TODO: kiemelni a dizájnokat ahol lehet és szétbontani a dart fájlokat ha kell

//GLOBÁLIS METÓDUSOK ELEJE ------------------------------------------------------------------------
Future<void> main() async {
  final WidgetsBinding widgetFrameworkFlutterEngineConnection = WidgetsFlutterBinding.ensureInitialized();
  //ahhoz hogy megfelelő időben, jelenjen meg a splash screen (az alkalmazás indításakor),
  FlutterNativeSplash.preserve(widgetsBinding: widgetFrameworkFlutterEngineConnection);

  await Preferences.init();
  await NotificationService.init();
  await Supabase.initialize(
    url: initUrl,
    publishableKey: publishableKey,
  );

  final String savedLanguageName = Preferences.getPreferredLanguage();
  final String localeCode = languageToLocale[savedLanguageName] ?? 'hu';

  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(Locale(localeCode)),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Figyeljük a LocaleProvider változásait, hogy a MaterialApp újraépüljön nyelvváltáskor.
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      // Itt adjuk át a MaterialApp-nak a Provider-ből érkező,
      // dinamikusan változó nyelvi beállítást!
      locale: localeProvider.locale,
      localizationsDelegates: const [
        // Ez a legfontosabb: ez köti össze az .arb fájlokat a kóddal.
        AppLocalizations.delegate,
        // A többi a Flutter beépített widgetjeinek fordításáért felel.
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Ez a lista is automatikusan generálódik az .arb fájlokból.
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<bool> _isLoggedInFuture;

  @override
  void initState() {
    super.initState();
    // A bejelentkezési logikát itt indítjuk, a UI felépítése után.
    _isLoggedInFuture = AuthService().tryAutoLoginByToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedInFuture,
      builder: (context, snapshot) {
        // Amíg a hálózati kérés fut, a Splash Screen látszik.
        if (snapshot.connectionState == ConnectionState.done) {
          FlutterNativeSplash.remove();
          if (snapshot.hasData && snapshot.data == true) {
            return const HomeScreen();
          }

          return const LoginUI();
        }

        // Amíg a future fut, egy üres konténert mutatunk, a splash screen takarja.
        return const SizedBox.shrink();
      },
    );
  }
}
//GLOBÁLIS METÓDUSOK VÉGE -------------------------------------------------------------------------
