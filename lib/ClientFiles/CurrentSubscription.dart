import 'package:flutter/material.dart';
import 'package:infinity/AppParts/ColorFromHex.dart';
import 'package:infinity/DataSet/Subscription.dart';
import 'package:animate_gradient/animate_gradient.dart';
import '../DataSet/Account.dart';
import '../DataSet/Gym.dart';

class CurrentSubscription extends StatefulWidget {
  Account account;
  CurrentSubscription({super.key, required this.account});

  @override
  State<CurrentSubscription> createState() => _CurrentSubscriptionState();
}

class _CurrentSubscriptionState extends State<CurrentSubscription> {

  Subscription subscription = Subscription("", "", "", 0, 0, 0, 0, 0, 0, 0);
  Gym gym = Gym("", "", "", "", "", "", "", "");
  Order order = Order();

  Future<void> GetMyGym(String GymDocID) async {
    gym = await Gym.GetGym(GymDocID);
    setState(() {});
  }

  Future<void> GetOrder( String GymDocID, String OrderDocID) async {
    var orderdoc = await Subscription.GetSubscriptionOrderFromDOCID(GymDocID, OrderDocID);
    print("INDATE");
    order.StartDate = orderdoc.data()["StartDate"].toDate();
    order.EndDate = orderdoc.data()["EndDate"].toDate();
    order.Status = orderdoc.data()["Status"].toString();
    order.PaymnetStatus = orderdoc.data()["PaymentStatus"].toString();

    setState(() {

    });
  }

  Future<void> Subsciptions() async {
    var Subs = await Subscription.GetCurrentSubscriptionOrder(widget.account.DocID);

    var SubscriptionDocID = Subs[0].data()["SubscriptionDocID"];
    var GymDocID = Subs[0].data()["GymDocID"];
    var OrderDocID = Subs[0].data()["OrderDocID"];

    GetMyGym(GymDocID);
    GetOrder( GymDocID, OrderDocID);

    var SubDetails = await Subscription.GetCurrentSubscriptionFromDocID(GymDocID, SubscriptionDocID);

    print( SubscriptionDocID + " " + GymDocID);

    if(SubDetails.exists) {
      subscription = Subscription(
          SubDetails.data()["SubScriptionNameIn"],
          SubDetails.data()["Details"],
          SubDetails.data()["Image"],
          double.parse(SubDetails.data()["Cost"]),
          double.parse(SubDetails.data()["MarginPer"]),
          double.parse(SubDetails.data()["DiscountPer"]),
          double.parse(SubDetails.data()["TaxPer"]),
          double.parse(SubDetails.data()["Price"]),
          int.parse(SubDetails.data()["Days"]),
          int.parse(SubDetails.data()["Months"]));

          setState(() {

          });
    }
  }

@override
  void initState() {
  Subsciptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: AnimateGradient(
        primaryBegin: Alignment.topLeft,
        primaryEnd: Alignment.bottomLeft,
        secondaryBegin: Alignment.bottomLeft,
        secondaryEnd: Alignment.topRight,
        primaryColors: [
          ColorFromHexCode("#27074D"),
          ColorFromHexCode("#760E85"),
          ColorFromHexCode("#DC0E38"),
        ],
        secondaryColors:  [
          ColorFromHexCode("#060107"),
          ColorFromHexCode("#760E85"),
          ColorFromHexCode("#27074D"),
        ],
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Text(gym.GymName.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: const Text("Membership Card", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.deepPurpleAccent),),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: <Widget>[
                  Container(
                    child: const Text("Start Date", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15, color: Colors.white),),
                  ),
                  const SizedBox(width: 30,),
                  Container(
                    child: const Text("End Date", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15, color: Colors.white),),
                  ),
                  const SizedBox(width: 40,),
                  Container(
                    child: const Text("Status", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15, color: Colors.white),),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: Text("${order.StartDate.day}/${order.StartDate.month}/${order.StartDate.year}", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white),),
                  ),
                  const SizedBox(width: 30,),
                  Container(
                    child: Text("${order.EndDate.day}/${order.EndDate.month}/${order.EndDate.year}", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white),),
                  ),
                  const SizedBox(width: 40,),
                  Container(
                    child: Text(order.Status.toString(), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white),),
                  ),
                ],
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text(widget.account.FullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
                  ),
                  const Icon(Icons.door_front_door_outlined, color: Colors.white),
                  const Icon(Icons.network_wifi, color: Colors.white,),
                ],

              ),
            ],
          ),
        ),
      ),
    );
  }
}
