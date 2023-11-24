import 'package:flutter/material.dart';
import 'package:infinity/AppParts/ColorFromHex.dart';

import '../DataSet/Gym.dart';


class GymHeader extends StatefulWidget {
  const GymHeader({super.key});

  @override
  State<GymHeader> createState() => _GymHeaderState();
}

class _GymHeaderState extends State<GymHeader> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 20, top: 25, bottom: 0, right: 10),
            alignment: Alignment.bottomLeft,
            child: Text(Gym.CurrentGym.GymName, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: ColorFromHexCode("#F41E74")),),
          ),
        ],
      ),
    );
  }
}
