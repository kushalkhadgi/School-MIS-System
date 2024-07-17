import 'package:flutter/material.dart';
import 'package:schoolmis/login/auth.dart';
// Import the StudentdashboardScreen for navigation

class StudentProfilePage extends StatelessWidget {
  final Student user;

  const StudentProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Profile',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            profileInfo('Email', user.email),
            profileInfo('Name', user.name),
            profileInfo('Blood Group', user.bloodgroup),
            profileInfo('Father Name', user.fathername),
            profileInfo('Mother Name', user.mothername),
            profileInfo('Aadhar Number', user.adhar),
            profileInfo('Address', user.address),
            profileInfo('Gender', user.gender),
            profileInfo('Date of Birth', user.dob),
            profileInfo('Occupation', user.occupation),
            profileInfo('Grade', user.grade),
            profileInfo('Parent Email', user.parentemail),
            profileInfo('Roll Number', user.rollno),
            profileInfo('Aim', user.placeofbirth), //POB  ->  AIM
            profileInfo('Religion', user.religion),
            profileInfo('Date of Admission', user.dateofadmission),
            profileInfo('Previous Percentage', user.previouspercentage),
            profileInfo('Mobile Number', user.mobilenumber),
            profileInfo('User ID', user.userid),
            profileInfo('School Registration ID', user.schoolregid),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      //   currentIndex: 1, // Set the current index for Profile page
      //   onTap: (index) {
      //     if (index == 0) {
      //       Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //         return StudentdashboardScreen(student: user); // Navigate to Home
      //       }));
      //     }
      //     // No need to navigate if already on the Profile page (index == 1)
      //   },
      // ),
    );
  }

  Widget profileInfo(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey, // Color for the label
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
