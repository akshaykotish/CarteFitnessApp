
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinity/AppParts/ColorFromHex.dart';

class StyleOfTexts{
  static TextStyle VerifyButton(){
    return TextStyle(
        color: ColorFromHexCode("#F120AF"),
        fontWeight: FontWeight.bold,
      fontSize: 18,
    );
  }

  static TextStyle NormalText(){
    return TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold
    );
  }

  static TextStyle ErrorMessage(){
    return TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold
    );
  }
}