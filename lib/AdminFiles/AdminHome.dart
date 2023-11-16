import 'package:flutter/material.dart';
import 'package:infinity/GymAccessParts/GymCordsSetup.dart';
import 'package:infinity/GymAccessParts/GymTracing.dart';

import '../DataSet/Account.dart';

class AdminHome extends StatefulWidget {
  Account account;
  AdminHome({super.key, required this.account});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  bool isShow = false;

  @override
  void initState() {
    if(widget.account.Admin == true)
      {
        setState(() {
          isShow = true;
        });
      }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isShow,
      child: Container(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>GymCordsSetup()));
              },
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.grey.shade100,
                child: Text("Setup Locations"),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>GymTracing()));
              },
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.grey.shade100,
                child: Text("Location Tracing"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
