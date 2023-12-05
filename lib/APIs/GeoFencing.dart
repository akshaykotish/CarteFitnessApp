

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:infinity/APIs/CurrentLocation.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../AppParts/Cookies.dart';

class GeoFencing{

  static List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  static StreamSubscription<List<WiFiAccessPoint>>? subscription;
  static bool shouldCheckCan = true;

  bool get isStreaming => subscription != null;


  static bool isinGym = false;

  static Future<void> CheckWiFi()
  async {
    try {
      // check if "can" startScan
      if (shouldCheckCan) {
        // check if can-startScan
        final can = await WiFiScan.instance.canStartScan();

        final result = await WiFiScan.instance.startScan();
        accessPoints = <WiFiAccessPoint>[];

        GetScanResults();

        shouldCheckCan = false;
        // if can-not, then show error
        if (can != CanStartScan.yes) {
          //if (mounted) kShowSnackBar(context, "Cannot start scan: $can");
          return;
        }
      }
    }catch(e){}
  }


  static void GetScanResults(){
    subscription = WiFiScan.instance.onScannedResultsAvailable
        .listen((result) => accessPoints = result);
  }


  static Future<void> WifiFounding() async {
     await CheckWiFi();

     for(int i=0; i<accessPoints.length; i++)
       {
         if(accessPoints[i].ssid.toString().toLowerCase() == "infinity_ground" || accessPoints[i].ssid.toString().toLowerCase() == "infinity_first")
           {
             GeoFencing.isinGym = true;
             print("AP found here ${accessPoints.length} ${accessPoints[0].ssid}");
           }
       }
  }

  static isItinGym()
  async {
    GeoFencing.isinGym = false;
    Position position = await CurrentLocation.GetPositions();

    double CurrentLat = position.latitude;
    double CurrentLong = position.longitude;

    String? GymDocID = await Cookies.ReadCookie("GymDocID");
    print("$CurrentLat and $CurrentLong");

    WifiFounding();
    if(GymDocID != null && GymDocID != "") {
      List<String>? Cords = await Cookies.ReadListCookie("GymCordinates");

      if (Cords != null) {
        var latsmall = double.parse(Cords[0].toString());
        var latbig = double.parse(Cords[1].toString());
        var longsmall = double.parse(Cords[2].toString());
        var longbig = double.parse(Cords[3].toString());

        if (CurrentLat >= latsmall && CurrentLat <= latbig &&
            CurrentLong >= longsmall && CurrentLong <= longbig) {
            GeoFencing.isinGym = true;
        }
      }
    }
    return isinGym;
  }


  void SendSignal(){

  }
}