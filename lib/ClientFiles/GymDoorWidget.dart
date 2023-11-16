import 'dart:async';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:infinity/APIs/CurrentLocation.dart';
import 'package:infinity/APIs/GeoFencing.dart';
import 'package:infinity/APIs/HandleDoorRequests.dart';
import 'package:infinity/AppParts/ColorFromHex.dart';
import 'package:infinity/DataSet/Account.dart';

class GymDoorWidget extends StatefulWidget {
  const GymDoorWidget({super.key});

  @override
  State<GymDoorWidget> createState() => _GymDoorWidgetState();
}

class _GymDoorWidgetState extends State<GymDoorWidget> {


  bool isopen = false;
  void CheckInGym(){
    isopen = GeoFencing.isinGym;
    setState(() {

    });
    Timer.periodic(Duration(seconds: 15), (timer) async {
      bool isit = await GeoFencing.isItinGym();
      print("Checking:- " + isit.toString());
      if(isopen != isit)
        {
          setState(() {
            isopen = isit;
          });
        }
    });
  }

  @override
  void initState() {
    super.initState();
    CheckInGym();
  }

  @override
  Widget build(BuildContext context) {
    return
      Visibility(
        visible:  isopen,
        child: GestureDetector(
          onTap: (){
            HandleDoorRequest.OpenDoor(Account.account);
          },
          child: Container(
            width: 250,
            height: 40,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: AnimateGradient(
              primaryColors: [
                ColorFromHexCode("#50c9c3"),
                ColorFromHexCode("#96deda"),
              ],
              secondaryColors: [
                ColorFromHexCode("#96deda"),
                ColorFromHexCode("#50c9c3"),
              ],
              child: Center(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.door_back_door_outlined),
                  Text("Tap to Open the Door", style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              )),
            ),
          )
        ),
      );
  }
}
