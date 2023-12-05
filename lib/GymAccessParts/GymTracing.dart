import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinity/APIs/CurrentLocation.dart';

import '../AppParts/Cookies.dart';
import '../DataSet/Gym.dart';


class GymTracing extends StatefulWidget {
  const GymTracing({super.key});

  @override
  State<GymTracing> createState() => _GymTracingState();
}

class _GymTracingState extends State<GymTracing> {

  List<double> Lats = <double>[];
  List<double> Longs = <double>[];

  double smallestLat = 199.8029929, biggestLat = 0;
  double smallestLong = 199.8029929, biggestLong = 0;


  late Timer timer;

  var wigs = <Widget>[];

  Future<void> StartTracing() async {
    print("Start");
    var _wigs = <Widget>[];
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      var Position = await CurrentLocation.GetPositions();
      Lats.add(Position.latitude);
      Longs.add(Position.longitude);
      _wigs.add(Container(child: Text("${Position.latitude} ${Position.longitude}"),));
      setState(() {
        wigs = _wigs;
      });
    });
  }

  void Calculate()
  {
    for(int i=0; i<Lats.length; i++)
      {
        if(smallestLat > Lats[i])
          {
            smallestLat = Lats[i];
          }
        else if(Lats[i] > biggestLat)
          {
            biggestLat = Lats[i];
          }


        if(smallestLong > Longs[i])
        {
          smallestLong = Longs[i];
        }
        else if(Longs[i] > biggestLong)
        {
          biggestLong = Longs[i];
        }

        if(i == Lats.length - 1)
          {
            setState(() {

            });
          }
      }
  }

  void StopTracing(){
    timer.cancel();
    Calculate();
    print("Stop");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                StartTracing();
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                child: const Text("Start"),
              ),
            ),
            GestureDetector(
              onTap: (){
                StopTracing();
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                child: const Text("Stop"),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Text("$smallestLat $biggestLat"),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Text("$smallestLong $biggestLong"),
            ),
            Container(
              height: 400,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey.shade200,
              child: SingleChildScrollView(
                child: Column(
                  children: wigs,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                String GymDocID = await Cookies.ReadCookie("GymDocID");
                Gym.SetGymCordinates(GymDocID, [smallestLat, biggestLat, smallestLong, biggestLong]);
                List<String> toCookie  = <String>[];
                toCookie.add(smallestLat.toString());
                toCookie.add(biggestLat.toString());
                toCookie.add(smallestLong.toString());
                toCookie.add(biggestLong.toString());

                Cookies.SetListCookie("GymCordinates", toCookie);
                Navigator.pop(context);
              },
              child: Container(
                child: const Text("Submit"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
