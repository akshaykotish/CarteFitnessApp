

import 'package:cloud_firestore/cloud_firestore.dart';

class Subscription{

  String SubscriptionName = "", Details = "", Image = "";
  double Cost = 0, MarginPer = 0, DiscountPer = 0, TaxPer = 0, Price = 0;
  int Days = 0, Month = 0;

  String Status = "";


  Subscription(this.SubscriptionName, this.Details, this.Image, this.Cost, this.MarginPer, this.DiscountPer, this.TaxPer, this.Price, this.Days, this.Month);


  static LoadSubscriptions(String GymDocID)
  async {
    var Subscriptions = await FirebaseFirestore.instance.collection("Gym").doc(GymDocID).collection("SubScriptions").get();
    return Subscriptions.docs;
  }

  static CreateSubscriptionOrder({
     String AccountDocID = "", GymDocID = "", SubscriptionDocID = "", DiscountPer = "", DiscountAmount = "", DiscountCode = "",
    TaxPer = "", Price = "", DateTime? StartDate, DateTime ? EndDate, Status = "InActive", Note = "", PaymentStatus = "", PaymentRecieved = "",
    PaymentMethod = "", PaymentID = "", PaymentDetails = "", PaymentIssue = "", DateTime? TimeStamp
}) async {
      
    var doc = await FirebaseFirestore.instance.collection("Gym").doc(GymDocID).collection("Orders").add({
      "AccountDocID": AccountDocID,
      "GymDocID": GymDocID,
      "SubscriptionDocID": SubscriptionDocID,
      "DiscountPer": DiscountPer,
      "DiscountAmount": DiscountAmount,
      "DiscountCode": DiscountCode,
      "TaxPer": TaxPer,
      "Price": Price,
      "StartDate": StartDate,
      "EndDate": EndDate,
      "Status": Status,
      "Note": Note,
      "PaymentStatus": PaymentStatus,
      "PaymentRecieved": PaymentRecieved,
      "PaymentMethod": PaymentMethod,
      "PaymentID": PaymentID,
      "PaymentDetails": PaymentDetails,
      "PaymentIssue": PaymentIssue,
      "TimeStamp": TimeStamp
    });

    LinkGymSubscriptionToProfile(AccountDocID, GymDocID, SubscriptionDocID, doc.id, EndDate, DateTime.now());
  }
  
  static Future<void> LinkGymSubscriptionToProfile(String AccountDocID, GymDocID, SubscriptionDocID, OrderDocID, ExpiryDate, TimeStamp)
  async {
    var doc = await FirebaseFirestore.instance.collection("Accounts").doc(AccountDocID).collection("Subscriptions").add({
      "GymDocID": GymDocID,
      "SubscriptionDocID": SubscriptionDocID,
      "OrderDocID": OrderDocID,
      "ExpiryDate": ExpiryDate,
      "TimeStamp": TimeStamp
    });
  }
  
  static GetCurrentSubscriptionOrder(String AccountDocID) async {
    var subs = await FirebaseFirestore.instance.collection("Accounts").doc(AccountDocID).collection("Subscriptions").where("ExpiryDate",  isGreaterThanOrEqualTo: DateTime.now()).get();
    print("Current Subscription:- ${subs.docs.length}");
    return subs.docs;
  }

  static GetCurrentSubscriptionFromDocID(String GymDocID, String SubscriptionDocID) async {
    var subs = await FirebaseFirestore.instance.collection("Gym").doc(GymDocID).collection("SubScriptions").doc(SubscriptionDocID).get();
    return subs;
  }


  static CheckDefaultSubscriptionOrder(String AccountDocID, String SubDocID) async {
    var subs = await FirebaseFirestore.instance.collection("Accounts").doc(AccountDocID).collection("Subscriptions").where("ExpiryDate",  isGreaterThanOrEqualTo: DateTime.now()).where("SubscriptionDocID", isEqualTo: SubDocID).get();
    print("Current Subscription:- ${subs.docs.length}");
    return subs.docs;
  }


  static GetSubscriptionOrderFromDOCID(String GymDocID, String OrderID) async {
    var subsorder = await FirebaseFirestore.instance.collection("Gym").doc(GymDocID).collection("Orders").doc(OrderID).get();
    return subsorder;
  }
}


class Order{
  DateTime StartDate  = DateTime.now();
  DateTime EndDate = DateTime.now();
  String Status = "InActive", PaymnetStatus = "UnPaid";
}