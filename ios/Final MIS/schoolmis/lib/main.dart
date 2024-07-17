import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:schoolmis/login/auth.dart';
// import 'package:schoolmis/student/your_video_player_widget.dart';
// import 'package:schoolmis/teacher/teacherdashboard_screen.dart';
// import 'package:schoolmis/student/studentdashboard_screen.dart';
// import 'package:schoolmis/login/login.dart';
// import 'package:schoolmis/student/profile_screen.dart';

import 'splash_screen.dart'; // Import your custom splash screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SchoolMis App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // Use your custom splash screen here
        home: splashscreen(),
      ),
    ),
  );
}
