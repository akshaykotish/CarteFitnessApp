import 'package:flutter/material.dart';
import 'package:infinity/AdminFiles/AdminHome.dart';
import 'package:infinity/ClientFiles/Attendance.dart';
import 'package:infinity/ClientFiles/GymDoorWidget.dart';

import '../DataSet/Account.dart';
import 'CurrentSubscription.dart';

class GymHome extends StatefulWidget {
  Account account;
  GymHome({super.key, required this.account});

  @override
  State<GymHome> createState() => _GymHomeState();
}

class _GymHomeState extends State<GymHome> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 130,
      child: Column(
        children: [
          AdminHome(account: widget.account,),
          CurrentSubscription(account: widget.account,),
          const GymDoorWidget(),
          const SizedBox(height: 30,),
          Attendance(account: widget.account,),
        ],
      )
    );
  }
}
