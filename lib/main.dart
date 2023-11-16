import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:infinity/APIs/BackgroundWorkers.dart';
import 'package:infinity/APIs/CurrentLocation.dart';
import 'package:infinity/Account/Login.dart';
import 'package:infinity/ClientFiles/Home.dart';
import 'package:infinity/ClientFiles/SetupGym.dart';
import 'package:infinity/SplashScreens/CarteScreen.dart';
import 'package:infinity/SplashScreens/GymScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await BackgroundWorkers.initializeService();
  await CurrentLocation.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    FlutterBackgroundService().invoke("setAsForeground");
    print("Executed");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GymScreen()
      ),
    );
  }
}