import 'package:flutter/material.dart';
import 'package:infinity/AppParts/ColorFromHex.dart';

import '../DataSet/Account.dart';


class Attendance extends StatefulWidget {
  Account account;
  Attendance({super.key, required this.account});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {

  var attendaceswid = <Widget>[];

  Future<void> LoadAttendance() async {
    var _attendaceswid = <Widget>[];


      var attandances = await Account.LoadAttendance(widget.account.DocID);


      for(int i=0; i<attandances.docs.length; i++)
        {
          var attend = attandances.docs[i];

          String keyDate = attend.id.toString();
          String newDate = keyDate.substring(0,2) + "/" + keyDate.substring(2,4) + "/" + keyDate.substring(4,8);

          print("attandances" + attandances.docs[i].data()["EntryTime"].toString());
          _attendaceswid.add(
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: ColorFromHexCode("#231539"),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   Row(
                     children: <Widget>[
                       Icon(Icons.co_present, color: Colors.white, size: 18,),
                       Text(newDate, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),),
                     ],
                   ),
                    Row(
                      children: <Widget>[
                        Text("Entry Time",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white),),
                        SizedBox(width: 100,),
                        Text("Exit Time",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white),),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(attend.data()["EntryTime"]!.toDate().toString(), style: TextStyle(fontSize: 10, color: Colors.white),),
                        SizedBox(width: 40,),
                        Text(attend.data()!["ExitTime"] == null ? "-" : attend.data()["ExitTime"].toDate().toString(), style: TextStyle(fontSize: 10, color: Colors.white),),
                      ],
                    )
                  ],
                ),
          ));

          if(i == attandances.docs.length - 1)
            {
              setState(() {
                attendaceswid = _attendaceswid;
              });
            }
        }

  }

  @override
  void initState() {
    super.initState();
    LoadAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 0, top: 0, bottom: 0),
              padding: EdgeInsets.all(10),
              child: Text("Attendance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: ColorFromHexCode("#ECF5FF")),)),
          Container(
            height: MediaQuery.of(context).size.height/2 - 100,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: attendaceswid,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
