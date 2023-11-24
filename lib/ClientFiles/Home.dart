import "dart:async";

import "package:flutter/material.dart";
import "package:infinity/APIs/CurrentLocation.dart";
import "package:infinity/ClientFiles/Footer.dart";
import "package:infinity/ClientFiles/GymHome.dart";
import "package:infinity/ClientFiles/Header.dart";
import "package:infinity/ClientFiles/SetupGym.dart";

import "../AppParts/ColorFromHex.dart";
import "../AppParts/Cookies.dart";
import "../DataSet/Account.dart";
import "../DataSet/Subscription.dart";
import "../SplashScreens/LocationPermission.dart";

class Home extends StatefulWidget {
  Account account;
  Home({super.key, required this.account});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  Future<void> CheckSubscription() async {
    String? CurrentSubscription = await Cookies.ReadCookie("DefaultSubDocID");

    var Subs =
        await Subscription.GetCurrentSubscriptionOrder(widget.account.DocID);

    print("IM here");
    if (Subs.length == 0) {
      Cookies.SetCookie("ToOpen", "SetupGym");
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SetupGym(account: widget.account)));
    } else if (Subs.length != 0 && CurrentSubscription == null) {
      SetDefaultSubscription(Subs);
    } else if (CurrentSubscription != null) {
      var defsub = await Subscription.CheckDefaultSubscriptionOrder(
          widget.account.DocID, CurrentSubscription);
      if (defsub.length == 0 && Subs.length != 0) {
        SetDefaultSubscription(Subs);
      }
    }
  }

  String strpos = "Locations";
  void UpdateinSeconds() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      var pos = await CurrentLocation.GetPositions();
      strpos = "${pos.latitude} ${pos.longitude}";
      setState(() {});
    });
  }

  Future<void> LocationPermissionScreen() async {
    String? locationPer = await Cookies.ReadCookie("LocationPermission");
    if (locationPer == null || locationPer == "NO") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LocationPermission()));
    }
  }

  @override
  void initState() {
    LocationPermissionScreen();
    CheckSubscription();
    UpdateinSeconds();
    Account.account = widget.account;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: ColorFromHexCode("#0E0B16"),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Header(),
              GymHome(
                account: widget.account,
              ),
              const Footer(),
              //Footer(),
            ],
          )),
    );
  }
}
