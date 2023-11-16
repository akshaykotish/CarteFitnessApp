import 'package:flutter/material.dart';
import 'package:infinity/AppParts/Cookies.dart';
import 'package:infinity/ClientFiles/Home.dart';
import 'package:infinity/DataSet/Subscription.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../AppParts/ColorFromHex.dart';
import '../DataSet/Account.dart';
import '../DataSet/Gym.dart';

class SubscriptionPage extends StatefulWidget {
  Account account;
  Gym gym;
  var gymdoc;

  SubscriptionPage({super.key, required this.account, required this.gym, this.gymdoc});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {

  var SubscriptionWidget = <Widget>[];

  late Subscription subscription_onclick;

  Future<void> LoadSubscription()
  async {
    var _SubscriptionWidget = <Widget>[];

    String GymDocID = await Cookies.ReadCookie("GymDocID");
    var Subscriptions = await Subscription.LoadSubscriptions(GymDocID);

    print(Subscriptions.length.toString() +  " GymDocID" + GymDocID);

    for(int i=0; i<Subscriptions.length; i++)
      {
        var subdoc = Subscriptions[i];


        Subscription subscription = new Subscription(
          subdoc.data()["SubScriptionNameIn"],
          subdoc.data()["Details"],
          subdoc.data()["Image"],
            double.parse(subdoc.data()["Cost"]),
            double.parse(subdoc.data()["MarginPer"]),
            double.parse(subdoc.data()["DiscountPer"]),
            double.parse(subdoc.data()["TaxPer"]),
            double.parse(subdoc.data()["Price"]),
            int.parse(subdoc.data()["Days"]),
            int.parse(subdoc.data()["Months"])
        );
        
        String SubDocID = subdoc.id;
        
        _SubscriptionWidget.add(
          GestureDetector(
            onTap: (){
              subscription_onclick = subscription;
              ClickSubscription(subscription, subdoc);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: ColorFromHexCode("#231539"),
              ),
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Container(
                      width: 100,
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Text(subscription.Month.toString(), style: TextStyle(fontSize: 30, color: Colors.white),),
                          ),
                          Text("Months", style: TextStyle(color: Colors.white),),
                        ],
                      )
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(subscription.SubscriptionName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                      Text("₹ " + subscription.Price.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white))
                    ],
                  ),
                ],
              ),
            ),
          )
        );

        if(i == Subscriptions.length - 1)
          {
            setState(() {
              SubscriptionWidget = _SubscriptionWidget;
            });
          }
      }

  }

  Razorpay _razorpay = Razorpay();

  void ClickSubscription(Subscription subscription, var SubDoc){
    print(SubDoc.id);
    Cookies.SetCookie("SubscriptionDocID", SubDoc.id);
    Cookies.SetCookie("ToOpen", "SubscriptionPage");

    var options = {
      'key': 'rzp_live_XjDUv1yfuZx0vJ',
      'amount': subscription.Price * 100,
      'name': widget.account.FullName,
      'GymDocID': widget.gymdoc.id,
      'subscriptiondocid': SubDoc.id,
      'clientdocid': widget.account.DocID,
      'description': "Subscription: " + SubDoc.id + "; Subscription Name: " + subscription.SubscriptionName + "; Price: " + subscription.Price.toString(),
      'prefill': {
        'contact': widget.account.Phone,
        'email': widget.account.Email
      }
    };

    _razorpay.open(options);

  }


  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {

    String GymDocID = await Cookies.ReadCookie("GymDocID");
    String SubscriptionDocID = await Cookies.ReadCookie("SubscriptionDocID");

    DateTime today = DateTime.now();

    Subscription.CreateSubscriptionOrder(
      AccountDocID: widget.account.DocID,
      GymDocID: GymDocID,
      SubscriptionDocID: SubscriptionDocID,
      DiscountPer: 0,
      DiscountAmount: 0,
      DiscountCode: "",
      TaxPer: subscription_onclick.TaxPer,
      Price: subscription_onclick.Price,
      StartDate: today,
      EndDate: DateTime(today.year, today.month + subscription_onclick.Month, today.day),
      Status: "Active",
      Note: "This subscription is by app",
      PaymentStatus: "Paid",
      PaymentRecieved: true,
      PaymentMethod: "RazorPay_" + response.orderId.toString(),
      PaymentID: response.paymentId,
      PaymentDetails: response.signature.toString() + ";" + response.orderId.toString(),
      PaymentIssue: "No",
      TimeStamp: DateTime.now()
    );

    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home(account: widget.account,)));
    Cookies.SetCookie("ToOpen", "Home");
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {

    String GymDocID = await Cookies.ReadCookie("GymDocID");
    String SubscriptionDocID = await Cookies.ReadCookie("SubscriptionDocID");

    DateTime today = DateTime.now();

    Subscription.CreateSubscriptionOrder(
        AccountDocID: widget.account.DocID,
        GymDocID: GymDocID,
        SubscriptionDocID: SubscriptionDocID,
        DiscountPer: 0,
        DiscountAmount: 0,
        DiscountCode: "",
        TaxPer: subscription_onclick.TaxPer,
        Price: subscription_onclick.Price,
        StartDate: today,
        EndDate: DateTime.now(),
        Status: "Failed Order",
        Note: "This subscription is by Failed during payment.",
        PaymentStatus: "Failed",
        PaymentRecieved: false,
        PaymentMethod: "RazorPay_" + response.error.toString(),
        PaymentID: response.code,
        PaymentDetails: response.message.toString() + ";" + response.error.toString(),
        PaymentIssue: "Yes",
        TimeStamp: DateTime.now()
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  void initState() {
    _razorpay = Razorpay();
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    LoadSubscription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: ColorFromHexCode("#130B20"),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.gym.GymName, style: TextStyle(color: ColorFromHexCode("#D71C6B"), fontWeight: FontWeight.bold, fontSize: 50),),
            SizedBox(height: 30,),
            Text("Choose Your Subscription", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),),
            Column(
              children: SubscriptionWidget,
            )
          ],
        )
      ),
    );
  }
}
