import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:schoolmis/login/login.dart';

class _splashscreenState extends State<splashscreen> {
  final pages = [
    Container(
      width: double.infinity,
      color: Color.fromARGB(255, 232, 149, 255),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 65),
            child: Image.asset(
              "assets/logo/test1.png",
              height: 300,
              width: 300,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20, left: 10),
            child: Text(
              "WELCOME TO EDUSAHAYOG!",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            "Where We Learn Together and Grow Together",
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    ),
    Container(
      width: double.infinity,
      color: Colors.yellow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Image.asset(
              "assets/logo/test2.png",
              height: 30,
              width: 30,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              "Your All-in-One Education Center",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "EDUSAHAYOG is a comprehensive school management app designed to bridge the educational gap in rural areas. Empowering students and teachers, it offers seamless access to study materials, direct teacher-student communication, result tracking, achievement recognition, and essential announcements, fostering a thriving learning community.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    ),
    Container(
      width: double.infinity,
      color: Color.fromARGB(255, 181, 238, 255),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Image.asset(
              "assets/logo/test3.png",
              height: 300,
              width: 300,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              "Village Wisdom, Education Freedom",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "An application service by Tech Pallotine students",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    ),
  ];

  int currentPage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            LiquidSwipe(
              pages: pages,
              enableLoop: true,
              fullTransitionValue: 1000,
              enableSideReveal: true,
              slideIconWidget: const Icon(Icons.arrow_back_ios),
              waveType: WaveType.liquidReveal,
              positionSlideIcon: 0.5,
              onPageChangeCallback: (page) {
                setState(() {
                  currentPage = page;
                });
                if (currentPage == pages.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              },
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(129, 104, 58, 183),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder => LoginPage()),
                    );
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
