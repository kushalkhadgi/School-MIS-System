import 'package:flutter/material.dart';
import 'package:schoolmis/login/auth.dart';

class TeacherProfilePage extends StatelessWidget {
  final Teacher user;

  const TeacherProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Email: ${user.email}'),
          ],
        ),
      ),
    );
  }
}
