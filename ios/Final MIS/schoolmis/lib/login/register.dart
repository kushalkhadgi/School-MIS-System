import 'package:flutter/material.dart';
import 'package:schoolmis/login/studentregister.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register Now',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 183, 83, 255),
              Color.fromARGB(255, 246, 255, 80),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/registerme.jpg', // Replace with your actual image path
                height: 250, // Adjust the height as needed
                width: 250, // Adjust the width as needed
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple),
                  shadowColor: MaterialStateProperty.all(Colors.grey),
                  elevation: MaterialStateProperty.all(10),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentRegisterPage(),
                    ),
                  );
                },
                child: const Text(
                  'Register New Student',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                    fontSize: 20, // Adjust the font size if needed
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   style: ButtonStyle(
              //     backgroundColor: MaterialStateProperty.all(Colors.amber),
              //     shadowColor: MaterialStateProperty.all(Colors.grey),
              //     elevation: MaterialStateProperty.all(10),
              //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //       RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(30.0),
              //         side: BorderSide(color: Colors.white),
              //       ),
              //     ),
              //   ),
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => TeacherRegisterPage(),
              //       ),
              //     );
              //   },
              //   child: Text('Register as Teacher'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
