import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:infinity/APIs/CurrentLocation.dart';
import 'package:infinity/AppParts/Cookies.dart';
import 'package:infinity/DataSet/Gym.dart';


class GymCordsSetup extends StatefulWidget {
  const GymCordsSetup({super.key});

  @override
  State<GymCordsSetup> createState() => _GymCordsSetupState();
}

class _GymCordsSetupState extends State<GymCordsSetup> {
  Map<String, String> cords  = <String, String>{};

  @override
  void initState() {
    cords["A"] = "Cord A";
    cords["B"] = "Cord B";
    cords["C"] = "Cord C";
    cords["D"] = "Cord D";
    super.initState();
  }

  Future<void> GetTheLocation(String key)
  async {
    Position position = await CurrentLocation.GetPositions();
    cords[key] = position.latitude.toString() + ";" + position.longitude.toString();
    setState(() {

    });
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
            GestureDetector(
              onTap: () {
                GetTheLocation("A");
              },
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                color: Colors.grey.shade100,
                child: Text(cords["A"].toString()),
              ),
            ),
            GestureDetector(
              onTap: () {
                GetTheLocation("B");
              },
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                color: Colors.grey.shade100,
                child: Text(cords["B"].toString()),
              ),
            ),
            GestureDetector(
              onTap: () {
                GetTheLocation("C");
              },
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                color: Colors.grey.shade100,
                child: Text(cords["C"].toString()),
              ),
            ),
            GestureDetector(
              onTap: () {
                GetTheLocation("D");
              },
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                color: Colors.grey.shade100,
                child: Text(cords["D"].toString()),
              ),
            ),
            GestureDetector(
              onTap: () async {
                String GymDocID = await Cookies.ReadCookie("GymDocID");
                //Gym.SetGymCordinates(GymDocID, cords);
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                color: Colors.grey.shade100,
                child: Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
