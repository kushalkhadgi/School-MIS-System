import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolmis/login/auth.dart';

class TeacherRegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  TeacherRegisterPage({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Registration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'name'),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;
                final name = nameController.text;
                final user = await auth.register(
                    email: email,
                    password: password,
                    name: name,
                    bloodgroup: '',
                    fathername: '',
                    mothername: '',
                    adhar: '',
                    address: '',
                    gender: '',
                    dob: '',
                    occupation: '',
                    grade: '',
                    parentemail: '',
                    rollno: '',
                    placeofbirth: '',
                    religion: '',
                    dateofadmission: '',
                    previouspercentage: '',
                    mobilenumber: '',
                    userid: '',
                    schoolregid: '',
                    isStudent: false);
                if (user != null) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Register as Teacher'),
            ),
          ],
        ),
      ),
    );
  }
}
