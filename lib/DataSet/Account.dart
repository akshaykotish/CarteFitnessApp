import 'package:cloud_firestore/cloud_firestore.dart';

class Account{

  static late Account account;

  String FirstName = "";
  String LastName = "";
  String FullName = "";
  String Phone = "";
  String Email = "";
  String Address1 = "";
  String Address2 = "";
  String City = "";
  String State = "";
  String Country = "";
  String PinCode = "";
  String LatLong = "";
  String AddressName = "";
  bool Admin = false;
  DateTime TimeStamp = DateTime.now();
  String DocID = "";

  Account(this.FirstName, this.LastName, this.FullName, this.Phone, this.Email, this.Address1, this.Address2, this.City, this.State, this.Country, this.PinCode, this.LatLong, this.AddressName, this.Admin, this.TimeStamp, this.DocID);

  static PushToFirebase(Account account) async {
    var db = await FirebaseFirestore.instance;
    var doc = await db.collection("Accounts").add({
      "FirstName": account.FirstName,
      "LastName": account.LastName,
      "FullName": account.FullName,
      "Phone": account.Phone,
      "Email": account.Email,
      "Address1": account.Address1,
      "Address2": account.Address2,
      "City": account.City,
      "State": account.State,
      "Country": account.Country,
      "PinCode": account.PinCode,
      "LatLong": account.LatLong,
      "AddressName": account.AddressName,
      "Admin": account.Admin,
      "TimeStamp": account.TimeStamp,
    });
    account.DocID = doc.id;
    print("User updated" + doc.id);
    return account;
  }

  static PushToFirebaseOnID(Account account, String DocID)
  async {
    var db = await FirebaseFirestore.instance;
    var doc = await db.collection("Accounts").doc(DocID).set({
      "FirstName": account.FirstName,
      "LastName": account.LastName,
      "FullName": account.FullName,
      "Phone": account.Phone,
      "Email": account.Email,
      "Address1": account.Address1,
      "Address2": account.Address2,
      "City": account.City,
      "State": account.State,
      "Country": account.Country,
      "PinCode": account.PinCode,
      "LatLong": account.LatLong,
      "AddressName": account.AddressName,
      "Admin": account.Admin,
      "TimeStamp": account.TimeStamp,
    });
    print("User updated");
    account.DocID = DocID;
    return account;
  }

  static PullFromFirebase(Phone) async {
    var db = await FirebaseFirestore.instance;
    var doc = await db.collection("Accounts").where(
        "Phone", isEqualTo: Phone).get();

    var account = null;

    if (doc.docs.length != 0) {
      var reqDoc = doc.docs[0];
      var data = reqDoc.data();
      account = new Account(
          data["FirstName"].toString(),
          data["LastName"].toString(),
          data["FullName"].toString(),
          data["Phone"].toString(),
          data["Email"].toString(),
          data["Address1"].toString(),
          data["Address2"].toString(),
          data["City"].toString(),
          data["State"].toString(),
          data["Country"].toString(),
          data["PinCode"].toString(),
          data["LatLong"].toString(),
          data["AddressName"].toString(),
          data["Admin"],
          DateTime.now(),
          reqDoc.id
      );
    }
    return account;
  }


   static Future<void> MarkAttendanceEntry(String DocID) async {
     String Date = DateTime.now().day.toString() + DateTime.now().month.toString() + DateTime.now().year.toString();

    var Att = await FirebaseFirestore.instance.collection("Accounts").doc(DocID).collection("Attendance").doc(Date).get();
    if(Att.exists == false) {
      var Attendance = await FirebaseFirestore.instance.collection("Accounts")
          .doc(DocID).collection("Attendance").doc(Date)
          .set({
        "EntryTime": DateTime.now()
      });
    }
  }
  static Future<void> MarkAttendanceExit(String DocID) async {
    String Date = DateTime.now().day.toString() + DateTime.now().month.toString() + DateTime.now().year.toString();
    var Attendance = await FirebaseFirestore.instance.collection("Accounts").doc(DocID).collection("Attendance").doc(Date).set({
      "ExitTime": DateTime.now()
    }, SetOptions(merge: true));
  }

  static LoadAttendance(String DocID)
  async {
    var Attendances = await FirebaseFirestore.instance.collection("Accounts").doc(DocID).collection("Attendance").orderBy("EntryTime",  descending: true).get();
    return Attendances;
  }
}