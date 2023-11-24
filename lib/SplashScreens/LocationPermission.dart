import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../APIs/BackgroundWorkers.dart';
import '../APIs/CurrentLocation.dart';
import '../AppParts/Cookies.dart';

class LocationPermission extends StatefulWidget {
  const LocationPermission({super.key});

  @override
  State<LocationPermission> createState() => _LocationPermissionState();
}

class _LocationPermissionState extends State<LocationPermission> {
  Future<void> MakeItWork() async {
    Cookies.SetCookie("LocationPermission", "YES");
    await BackgroundWorkers.initializeService();
    await CurrentLocation.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Location Permission",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                  "We want to use your location in background to verify and monitor your presence inside the gym. We didn't read or share your location information for our benefits, it's only accesed by the app and it's only limit to your device. We didn't store location history on our database."),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    MakeItWork();
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: Colors.black,
                    width: 300,
                    height: 40,
                    child: Center(
                      child: Text(
                        "Tap here to allow",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
