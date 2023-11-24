

import 'package:geolocator/geolocator.dart';
import 'package:infinity/APIs/CurrentLocation.dart';

import '../AppParts/Cookies.dart';

class GeoFencing{

  static bool isinGym = false;

  static isItinGym()
  async {

    GeoFencing.isinGym = false;
    Position position = await CurrentLocation.GetPositions();

    double CurrentLat = position.latitude;
    double CurrentLong = position.longitude;

    String? GymDocID = await Cookies.ReadCookie("GymDocID");

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
        else {
          GeoFencing.isinGym = false;
        }
      }
    }

    return isinGym;
  }


  void SendSignal(){

  }
}