import 'package:flutter/material.dart';

class LoginDesign {
  static BoxDecoration inputBoxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
  );

  static InputDecoration inputDecoration({String labelText = ''}) {
    return InputDecoration(
      labelText: labelText,
      border: InputBorder.none,
    );
  }

  static ButtonStyle loginButtonStyle = ElevatedButton.styleFrom(
    // primaryColor:Color.fromRGBO(33, 150, 243, 1), // Set login button background color
    backgroundColor : Colors.blue,
  );

  static ButtonStyle registerButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.green, // Set register button background color=
  );
}
