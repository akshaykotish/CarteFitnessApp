import 'package:flutter/material.dart';
import 'package:infinity/AppParts/ColorFromHex.dart';
import 'package:infinity/AppParts/Cookies.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infinity/AppParts/StyleOfButtons.dart';
import 'package:infinity/AppParts/StyleOfTexts.dart';
import 'package:infinity/ClientFiles/SetupGym.dart';
import 'package:infinity/DataSet/Account.dart';
import 'package:infinity/DataSet/Subscription.dart';

import '../ClientFiles/Home.dart';
import '../DataSet/Gym.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isRequestOTP = true;
  bool isOTP = false;
  bool isVerify = false;
  bool isReqestOTPAgain = false;

  String ErrorMessage = "";

  TextEditingController fullName = TextEditingController();
  TextEditingController Phone = TextEditingController();
  TextEditingController OTP = TextEditingController();

  int requestOTPTime = 60;

  var receivedID;

  Future RequestOTP() async{
    _auth.verifyPhoneNumber(
        phoneNumber: "+91" + Phone.text,
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then(
                (value) => print('Logged In Successfully'),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          ErrorMessage = "Please enter correct OTP.";
          setState(() {

          });
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          receivedID = verificationId;
          isOTP = true;
          isVerify = true;
          isRequestOTP = false;

          setState(() {});

          Timer(Duration(seconds: 60), (){
            isReqestOTPAgain = true;
            setState(() {

            });
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('TimeOut');
          isReqestOTPAgain = true;
          setState(() {

          });
        }
    );
  }

  Future<void> verifyOTPCode() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: receivedID,
      smsCode: OTP.text,
    );
    await _auth
        .signInWithCredential(credential)
        .then((value) async {
      print('User Login In Successful');

      Account userData = Account("", "", fullName.text, "+91"+Phone.text, "", "", "", "", "", "", "", "", "", false, DateTime.now(), "");
      var account = await Account.PullFromFirebase("+91" + Phone.text);
      if(account != null && account.DocID != "")
      {
        account.FullName = fullName.text;
        userData = await Account.PushToFirebaseOnID(account, account.DocID);
      }
      else{
        userData = await Account.PushToFirebase(userData);
      }
      //print("DoC ID is " + userData.DocID + " and " + userData.Address1 + " or " + account.Address1);

      ErrorMessage = "Login suceed, wait or verify again.";
      setState(() {

      });

      Cookies.SetCookie("Phone", Phone.text);
      //Cookies.SetCookie("ToOpen", "Home");

      var CurrentSubscription  = await Subscription.GetCurrentSubscriptionOrder(account.DocID);
      if(CurrentSubscription.length != 0)
        {
          Cookies.SetCookie("ToOpen", "Home");

          String GymDocID = CurrentSubscription[0].data()["GymDocID"];
          String OrderDocID = CurrentSubscription[0].data()["OrderDocID"];
          String SubscriptionDocID = CurrentSubscription[0].data()["SubscriptionDocID"];

          Cookies.SetCookie("SubscriptionDocID", SubscriptionDocID);
          Cookies.SetCookie("GymDocID", GymDocID);
          Cookies.SetCookie("OrderDocID", OrderDocID);

          Gym.CurrentGym = await Gym.GetGym(GymDocID);

          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => Home(account: userData)));
        }
      else{
        Cookies.SetCookie("ToOpen", "SetupGym");

        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => SetupGym(account: userData)));
      }


      //Cookies.SetCookie("ToOpen", "SetupGym");

      //Navigator.pop(context);
     // Navigator.push(context, MaterialPageRoute(builder: (context) => SetupGym(account: userData)));

    });
    // .onError((error, stackTrace){
    //       ErrorMessage = "Please enter correct OTP.";
    //       setState(() {
    //
    //       });
    //   });
  }

  @override
  void dispose() {
    _auth = FirebaseAuth.instance;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorFromHexCode("#130B20"),
        margin: const EdgeInsets.only(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text("Login", style: TextStyle(color: ColorFromHexCode("#D71C6B"), fontWeight: FontWeight.bold, fontSize: 30),),
            ),
            SizedBox(height: 50,),
            Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextField (
                  controller: fullName,
                  decoration: InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Full Name',
                    fillColor: ColorFromHexCode("#24163A"),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey.shade100),
                    labelStyle: TextStyle(color: Colors.grey.shade100),
                  ),
                  style: TextStyle(color: Colors.white),
                )
            ),
            Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextField (
                  controller: Phone,
                  decoration: InputDecoration(
                      prefix: Text("+91"),
                      labelText: 'Phone',
                      hintText: '1234567890',
                      fillColor: ColorFromHexCode("#24163A"),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey.shade100),
                  labelStyle: TextStyle(color: Colors.grey.shade100),
                  ),
                  maxLength: 10,
                  style: TextStyle(color: Colors.white),
                )
            ),
            Visibility(
              visible: isRequestOTP,
              child: GestureDetector(
                onTap: (){
                  isReqestOTPAgain = false;
                  RequestOTP();
                },
                child: Container(
                  width: 200,
                  decoration: StyleOfButtons.VerifyButton(),
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                  child: Center(child: Text("Request OTP", style: StyleOfTexts.VerifyButton(),)),
                ),
              ),
            ),
            Visibility(
              visible: isOTP,
              child: Container(
                width: MediaQuery.of(context).size.width/2 + MediaQuery.of(context).size.width/3,
                height: 80,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width/2,
                      height: 80,
                      child:  TextField (
                        maxLength: 6,
                        style: TextStyle(color: Colors.white),
                        controller: OTP,
                        decoration: InputDecoration(
                            labelText: 'OTP',
                            hintText: 'OTP',
                          fillColor: ColorFromHexCode("#24163A"),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey.shade100),
                          labelStyle: TextStyle(color: Colors.grey.shade100),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width/3,
                      height: 80,
                      child: Visibility(
                        visible: isReqestOTPAgain,
                        child: GestureDetector(
                          onTap: (){
                            RequestOTP();
                            ErrorMessage = "OTP resent.";
                            setState(() {

                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: StyleOfButtons.VerifyButton(),
                            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                            child: Text("Request OTP", style: StyleOfTexts.VerifyButton(),),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isVerify,
              child: GestureDetector(
                onTap: (){
                  verifyOTPCode();
                },
                child: Container(
                  decoration: StyleOfButtons.VerifyButton(),
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Text("Verify", style: StyleOfTexts.VerifyButton(),),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Text(ErrorMessage, style: StyleOfTexts.ErrorMessage(),),
            ),
          ],
        ),
      ),
    );
  }
}
