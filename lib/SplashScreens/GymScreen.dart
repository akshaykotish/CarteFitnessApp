import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinity/SplashScreens/CarteScreen.dart';

import '../AppParts/ColorFromHex.dart';
import '../AppParts/Cookies.dart';
import '../DataSet/Gym.dart';

class GymScreen extends StatefulWidget {
  const GymScreen({super.key});

  @override
  State<GymScreen> createState() => _GymScreenState();
}

class _GymScreenState extends State<GymScreen> {

  LoadGymCords()
  async {
    String? GymDocID = await Cookies.ReadCookie("GymDocID");

    if(GymDocID != null && GymDocID != "") {
      List<double> Cords = await Gym.GetGymCordinates(GymDocID);
      List<String> toCookie  = <String>[];
      toCookie.add(Cords[0].toString());
      toCookie.add(Cords[1].toString());
      toCookie.add(Cords[2].toString());
      toCookie.add(Cords[3].toString());

      Cookies.SetListCookie("GymCordinates", toCookie);
      print("Saved GymCordinates");
    }
  }

  LoadGym() async {
    String? GymDocID = await Cookies.ReadCookie("GymDocID");

    if(GymDocID == null){
      print("No Gym");
    }
    else{
        Gym.CurrentGym = await Gym.GetGym(GymDocID);
        Cookies.SetCookie("GymName", Gym.CurrentGym.GymName);
        GYMNAME = Gym.CurrentGym.GymName;
        setState(() {

        });
    }
  }

  String GYMNAME = "It's a Carte Gym";
  Future<void> CheckGymName() async {
    String? ster = await Cookies.ReadCookie("GymName");
    print("$ster ster");
    if(ster != null)
      {
        GYMNAME = ster;
        setState(() {

        });
      }
  }

  @override
  void initState() {
    CheckGymName();
    LoadGym();
    LoadGymCords();
    super.initState();
    Timer(const Duration(
      seconds: 3,
    ), (){
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const CarteScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorFromHexCode("#130B20"),
        child: Center(
          child: Text(GYMNAME, style: TextStyle(color: ColorFromHexCode("#D71C6B"), fontWeight: FontWeight.bold, fontSize: 30), textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}
