

import 'dart:async';

import '../AppParts/Cookies.dart';
import '../DataSet/Account.dart';
import '../DataSet/Gym.dart';

class HandleDoorRequest{
  static late DateTime LastRequestTime;

  static void SetLastRequest(){
    Cookies.SetCookie("LastDoorRequest", DateTime.now().toString());
  }

  static  Future<DateTime> GetLastRequest() async {
    String LastDoorRequest = await Cookies.ReadCookie("LastDoorRequest");
    DateTime dateTime = DateTime.parse(LastDoorRequest);
    return dateTime;
  }

  static CheckTheLastRequest()
  async {
    String? LastDoorRequest = await Cookies.ReadCookie("LastDoorRequest");

    print("AV1$LastDoorRequest");
    if(LastDoorRequest == null)
      {
        print("AV12");
        return true;
      }

    DateTime dateTime = await GetLastRequest();
    int diff = dateTime.difference(DateTime.now()).inMinutes.abs();
    print("AV2$diff");
    if(diff > 60)
      {
        print("AV3");
        return true;
      }
    print("AV4");
    return false;
  }


  static Future<void> OpenDoor(Account account) async {
    String GymDocID = await Cookies.ReadCookie("GymDocID");
    Gym.ControlGymDoor(GymDocID, true);
    print("Door Unlocked");
    Gym.GymDoorLog(GymDocID, true, Account.account);
    Timer(const Duration(seconds: 20), (){
      Gym.ControlGymDoor(GymDocID, false);
      Gym.GymDoorLog(GymDocID, false, Account.account);
    });
    }
}