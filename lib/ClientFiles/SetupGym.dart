import 'package:flutter/material.dart';
import 'package:infinity/AppParts/Cookies.dart';
import 'package:infinity/ClientFiles/SubscriptionPage.dart';

import '../AppParts/ColorFromHex.dart';
import '../DataSet/Account.dart';
import '../DataSet/Gym.dart';

class SetupGym extends StatefulWidget {
  Account account;
   SetupGym({super.key, required this.account});

  @override
  State<SetupGym> createState() => _SetupGymState();
}

class _SetupGymState extends State<SetupGym> {

  var GymsWidgets = <Widget>[];

  Future<void> LoadGyms() async {
    var _GymsWidgets = <Widget>[];
    var Gyms = await Gym.GetGyms();
   for(int i=0; i<Gyms.length; i++) {
     Gym gym = Gym(
         Gyms[i].data()["GymName"].toString(),
         Gyms[i].data()["Phone"].toString(),
         Gyms[i].data()["Email"].toString(),
         Gyms[i].data()["Address1"].toString(),
         Gyms[i].data()["Address2"].toString(),
         Gyms[i].data()["City"].toString(),
         Gyms[i].data()["State"].toString(),
         Gyms[i].data()["Country"].toString());
     _GymsWidgets.add(
         GestureDetector(
           onTap: (){
             OnGymClick(gym, Gyms[i]);
           },
           child: Container(
             decoration: BoxDecoration(
               color: ColorFromHexCode("#231539"),
               borderRadius: BorderRadius.all(Radius.circular(20))
             ),
             padding: EdgeInsets.all(20),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(gym.GymName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                 Text(gym.Address1 + " "  + gym.Address2 + " " + gym.City, style: TextStyle(fontSize: 10, color: Colors.white),),
               ],
             ),
           ),
         )
     );

     print(_GymsWidgets.length);
     if (i == Gyms.length - 1)
     {
         setState(() {
           GymsWidgets = _GymsWidgets;
         });
     }
     }

  }


  void OnGymClick(gym, gymdata){
    print(gymdata.id);
    Cookies.SetCookie("GymDocID", gymdata.id);
    Cookies.SetCookie("ToOpen", "SubscriptionPage");
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionPage(account: widget.account, gym: gym, gymdoc: gymdata,)));
  }

  @override
  void initState() {
    super.initState();
    LoadGyms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: ColorFromHexCode("#130B20"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Choose your Gym...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorFromHexCode("#F41F75")),),
            SizedBox(height: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: GymsWidgets,
            ),
          ],
        ),
      ),
    );
  }
}