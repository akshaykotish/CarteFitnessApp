

import 'package:cloud_firestore/cloud_firestore.dart';

import 'Account.dart';

class Gym{

  static late Gym CurrentGym;

  late String GymName, Phone, Email, Address1, Address2, City, State, Country;

  Gym(this.GymName, this.Phone, this.Email, this.Address1, this.Address2, this.City, this.State, this.Country);

  static GetGyms() async {
    var gyms  = await FirebaseFirestore.instance.collection("Gym").get();
    return gyms.docs;
  }
  
  static GetGym(String DocID)
  async {
    var gymdoc = await FirebaseFirestore.instance.collection("Gym").doc(DocID).get();

    Gym gym = Gym("", "", "", "", "", "", "", "");
    
    if(gymdoc.exists)
      {
        gym = Gym(
            gymdoc.data()!["GymName"].toString(),
            gymdoc.data()!["Phone"].toString(),
            gymdoc.data()!["Email"].toString(),
            gymdoc.data()!["Address1"].toString(),
            gymdoc.data()!["Address2"].toString(),
            gymdoc.data()!["City"].toString(),
            gymdoc.data()!["State"].toString(),
            gymdoc.data()!["Country"].toString());
      }

    return gym;
  }


  static GetGymDoc(String DocID)
  async {
    var gymdoc = await FirebaseFirestore.instance.collection("Gym").doc(DocID).get();
    return gymdoc;
  }

  static SetGymCordinates(String GymDocID, List<double> AllCords)
  async {
    var GymCords = await FirebaseFirestore.instance.collection("Gym").doc(GymDocID).set({
      "Cords": AllCords
    }, SetOptions(merge: true));
  }

  static GetGymCordinates(String GymDocID)
  async {
    List<double> LatLongs = <double>[];
    var GymCords = await FirebaseFirestore.instance.collection("Gym").doc(GymDocID).get();
    if(GymCords.exists)
      {
        LatLongs = GymCords.data()!["Cords"].cast<double>();
      }
    return LatLongs;
  }


  static ControlGymDoor(String GymDocID, bool status)
  async {
    var GymDoor = await FirebaseFirestore.instance.collection("Gym").doc(GymDocID).set({
      "DoorisLock": status,
    }, SetOptions(merge: true));
  }


  static GymDoorLog(String GymDocID, bool status, Account account)
  async {
    var GymDoor = await FirebaseFirestore.instance.collection("Gym").doc(GymDocID).collection("DoorLogs").add({
      "AccountDocID": account.DocID,
      "Phone": account.Phone,
      "Status": status,
      "TimeStamp": DateTime.now(),
    });
  }

}