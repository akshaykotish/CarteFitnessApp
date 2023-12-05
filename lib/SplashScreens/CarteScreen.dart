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
import '../DataSet/Subscription.dart';

class CarteScreen extends StatefulWidget {
  const CarteScreen({super.key});

  @override
  State<CarteScreen> createState() => _CarteScreenState();
}

class _CarteScreenState extends State<CarteScreen> {
  String? ToOpen = "Home";
  Future<void> CheckSubscriptionStatus(GymDocID, OrderID) async {
    var SubscriptionOrder =
    await Subscription.GetSubscriptionOrderFromDOCID(GymDocID, OrderID);
    if (SubscriptionOrder.exists) {
      String status = SubscriptionOrder.data()["Status"];
      if (status != "Active") {
        Cookies.SetCookie("SubscriptionDocID", "");
        Cookies.SetCookie("GymDocID", "");
        Cookies.SetCookie("OrderDocID", "");
        Cookies.SetCookie("ToOpen", "Login");
      }
    }
  }

  Future<void> SetDefaultSubscription(Subs) async {
    if (Subs.length != 0) {
      var SubScriptionID = Subs[0].data()["SubscriptionDocID"];
      var GymDocID = Subs[0].data()["GymDocID"];
      var OrderDocID = Subs[0].data()["OrderDocID"];
      Cookies.SetCookie("SubscriptionDocID", SubScriptionID);
      Cookies.SetCookie("GymDocID", GymDocID);
      Cookies.SetCookie("OrderDocID", OrderDocID);

      CheckSubscriptionStatus(GymDocID, OrderDocID);
    }
  }

  Future<void> CheckSubscription(Account account) async {
    String? CurrentSubscription = await Cookies.ReadCookie("DefaultSubDocID");

    var Subs = await Subscription.GetCurrentSubscriptionOrder(account.DocID);

    print(Subs.length);
    if (Subs.length == 0) {

    } else if (Subs.length != 0 && CurrentSubscription == null) {
      ToOpen = "Home";
      Cookies.SetCookie("ToOpen", "Home");
      await SetDefaultSubscription(Subs);
    } else if (CurrentSubscription != null) {
      ToOpen = "Home";
      Cookies.SetCookie("ToOpen", "Home");
      var defsub = await Subscription.CheckDefaultSubscriptionOrder(account.DocID, CurrentSubscription);
      if (defsub.length == 0 && Subs.length != 0) {
        ToOpen = "Home";
        Cookies.SetCookie("ToOpen", "Home");
        await SetDefaultSubscription(Subs);
      }
    }
  }

  Setup() async {

    print("BBB0");
    String? Phone = await Cookies.ReadCookie("Phone");
    if(Phone != null) {
      print("BBB01 ${Phone}");
      Account account = await Account.PullFromFirebase("+91$Phone");
      await CheckSubscription(account);
    }

    print("BBB1");
    String? ToOpen = await Cookies.ReadCookie("ToOpen");

    print("BBB2");
    print("ToOpen" + ToOpen.toString());
    if(ToOpen != null) {
      if(ToOpen == "Home")
      {
        print("BBB3");
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