import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//NotificationService OSZTÁLY ELEJE ---------------------------------------------------------------
class NotificationService {
//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------
  //létrehozunk egy példányt a FlutterLocalNotificationsPlugin osztályból ami a értesítések megjelenítéséért fog felelni
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    //ez a metódus a main.dart betöltésekor inicializálja az értesítések beállításait (értesítése ikon)
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings: settings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    //ez a metódus jeleníti meg az értesítést a megadott beállításokkal (priorítás, fontosság, stílus, és ikon)
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'notifications',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(body),
      icon: '@drawable/ic_notification',
      colorized: true,
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      //egyedi azonosítót kap ami a "Unix epoch" óta eltelt idő osztva 1000-el,
      //majd kerekítve a 0-hoz közel (debugnál hasznos)
      //megjelenítjük a megadott title-t és body-t (ami tetszőleges lehet!)
      title: title,
      body: body,
      notificationDetails:
          platformDetails, //androidra szánt beállítások-al jelenítse meg
    );
  }
//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------
}
//NotificationService OSZTÁLY VÉGE ----------------------------------------------------------------
