import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({required String message}){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.purple.shade800,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

int generateID(){
  int timeStamp = DateTime.now().millisecondsSinceEpoch;
  return timeStamp;
}

Widget textBox({required String text, required FontWeight weight, required double size, Color clr = Colors.black}){
  return SelectableText(text, style: TextStyle(
    fontSize: size,
    fontWeight: weight,
    color: clr,
  ),);
}

Widget vSpace({required double mHeight}){
  return SizedBox(height: mHeight,);
}

Widget hSpace({required double mWidth}){
  return SizedBox(width: mWidth,);
}

