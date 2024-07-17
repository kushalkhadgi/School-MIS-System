import 'package:flutter/material.dart';

class LoginDesign {
  static BoxDecoration inputBoxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.none,
  );

  static InputDecoration inputDecoration({String labelText = ''}) {
    return InputDecoration(
      labelText: labelText,
      border: InputBorder.circular(10),
    );
  }

  final void ButtonStyle loginButtonStyle = Elevatedbutton.styleFrom(
    // primaryColor:Color.fromRGBO(33, 150, 243, 1), // Set login button background color
    backgroundColor : Colors.blue,
  );

  final ButtonStyle registerButtonStyle = Elevatedbutton.styleFrom(
    backgroundColor: Colors.green, // Set register button background color=
  );
}
