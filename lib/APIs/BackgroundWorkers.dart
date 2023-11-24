import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:infinity/APIs/HandleDoorRequests.dart';
import 'package:infinity/DataSet/Account.dart';

import '../AppParts/Cookies.dart';
import 'GeoFencing.dart';

class BackgroundWorkers {
  // this will be used as notification channel id
  static String notificationChannelId = 'my_foreground';

// this will be used for notification id, So you can update your custom notification with this id.
  static int notificationId = 888;

  static initializeService() async {
    final service = FlutterBackgroundService();

    /// OPTIONAL, using custom notification channel id
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground', // id
      'MY FOREGROUND SERVICE', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max, // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (Platform.isIOS || Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          iOS: DarwinInitializationSettings(),
          android: AndroidInitializationSettings('ic_bg_service_small'),
        ),
      );
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: true,

        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'Carte Gym App',
        initialNotificationContent: 'App on Duty.',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: onIosBackground,
      ),
    );

    service.startService();
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    return true;
  }

  void BGTask() {}

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();
    await Firebase.initializeApp();

    // For flutter prior to version 3.0.0
    // We have to register the plugin manually

    /// OPTIONAL when use custom notification
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    String? Phone = await Cookies.ReadCookie("Phone");

    if (Phone != null) {
      Account account = await Account.PullFromFirebase("+91$Phone");
      Account.account = account;

      // bring to foreground
      int UpdateExitTime = 0;
      Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (service is AndroidServiceInstance) {
          if (await service.isForegroundService()) {
            bool isit = await GeoFencing.isItinGym();
            if (isit == true) {
              if (UpdateExitTime == 0) {
                bool checkthereq =
                    await HandleDoorRequest.CheckTheLastRequest();
                if (checkthereq == true) {
                  HandleDoorRequest.SetLastRequest();
                  HandleDoorRequest.OpenDoor(account);
                  Account.MarkAttendanceEntry(account.DocID);
                }
              }

              if (UpdateExitTime == 300) {
                //Update on Firebase
                Account.MarkAttendanceExit(account.DocID);
                UpdateExitTime = 0;
              }
            }
          }
        }

        bool isit = await GeoFencing.isItinGym();
        if (isit == true) {
          if (UpdateExitTime == 0) {
            bool checkthereq = await HandleDoorRequest.CheckTheLastRequest();
            if (checkthereq == true) {
              HandleDoorRequest.SetLastRequest();
              HandleDoorRequest.OpenDoor(account);
              Account.MarkAttendanceEntry(account.DocID);
            }
          }

          if (UpdateExitTime == 300) {
            //Update on Firebase
            Account.MarkAttendanceExit(account.DocID);

            UpdateExitTime = 0;
          }
        }

        /// you can see this log in logcat
        //print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

        // test using external plugin
        final deviceInfo = DeviceInfoPlugin();
        String? device;
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          device = androidInfo.model;
        }

        if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          device = iosInfo.model;
        }

        service.invoke(
          'update',
          {
            "current_date": DateTime.now().toIso8601String(),
            "device": device,
          },
        );
        UpdateExitTime++;
      });
    }
  }
}
