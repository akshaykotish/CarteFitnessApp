import 'package:flutter/material.dart';
import 'package:infinity/AppParts/ColorFromHex.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.home_filled, color: ColorFromHexCode("#C61463"), size: 45,)
        ],
      ),
    );
  }
}
