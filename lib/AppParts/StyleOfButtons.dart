
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinity/AppParts/ColorFromHex.dart';

class StyleOfButtons{
  static BoxDecoration VerifyButton(){
    return BoxDecoration(
        color: ColorFromHexCode('#231539'),
        borderRadius: BorderRadius.all(Radius.circular(10))
    );
  }


  static BoxDecoration NormalButton(){
    return BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.all(Radius.circular(10))
    );
  }
}