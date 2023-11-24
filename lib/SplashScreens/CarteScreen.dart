import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinity/Account/Login.dart';
//import 'package:vegiehome/Account/SetupAddress.dart';
import 'package:infinity/ClientFiles/Home.dart';
import 'package:infinity/AppParts/Cookies.dart';
import 'package:infinity/ClientFiles/SetupGym.dart';
import 'package:infinity/ClientFiles/SubscriptionPage.dart';

import '../AppParts/ColorFromHex.dart';
import '../DataSet/Account.dart';
import '../DataSet/Gym.dart';

class CarteScreen extends StatefulWidget {
  const CarteScreen({super.key});

  @override
  State<CarteScreen> createState() => _CarteScreenState();
}

class _CarteScreenState extends State<CarteScreen> {

  Setup() async {
    String? ToOpen = await Cookies.ReadCookie("ToOpen");

    if(ToOpen != null) {
      if(ToOpen == "Home")
      {
        Timer(const Duration(seconds: 5), () async {
          String? Phone = await Cookies.ReadCookie("Phone");
          Account account = await Account.PullFromFirebase("+91$Phone");
          Account.account = account;
          print("AC ${account.Admin}");
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => Home(account: account)));
        });
      }
      else if(ToOpen == "SetupAddress")
      {
        Timer(const Duration(seconds: 2), () async {
          String? Phone =await Cookies.ReadCookie("Phone");
          Account account = await Account.PullFromFirebase("+91$Phone");
          Navigator.pop(context);
          //Navigator.push(context, MaterialPageRoute(builder: (context) => SetupAddress(account: account)));
        });
      }
      else if(ToOpen == "SetupGym")
      {
        Timer(const Duration(seconds: 5), () async {
          String? Phone =await Cookies.ReadCookie("Phone");
          Account account = await Account.PullFromFirebase("+91$Phone");
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => SetupGym(account: account)));
        });
      }
      else if(ToOpen == "SubscriptionPage")
      {
        Timer(const Duration(seconds: 5), () async {
          String? Phone =await Cookies.ReadCookie("Phone");
          Account account = await Account.PullFromFirebase("+91$Phone");

          String GymDocID = await Cookies.ReadCookie("GymDocID");
          Gym gym =  await Gym.GetGym(GymDocID);
          var GymDoc = await Gym.GetGymDoc(GymDocID);

          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionPage(account: account, gym: gym, gymdoc: GymDoc,)));
        });
      }
      else{
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
      }
    }
    else{
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
    }
  }

  @override
  void initState() {
    Cookies.init();
    super.initState();
    Setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorFromHexCode("#130B20"),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Carte Fitness", style: TextStyle(color: ColorFromHexCode("#315EFF"), fontWeight: FontWeight.bold, fontSize: 40), textAlign: TextAlign.center,),
            Text("An Akshay Kotish & Co. Product", style: TextStyle(color: ColorFromHexCode("#8F8F8F"), fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}