import 'package:flutter/material.dart';
import 'package:schoolmis/login/auth.dart';
// Import the StudentdashboardScreen for navigation

class StudentProfilePage extends StatefulWidget {
  final Student user;

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
            'Email', user.email,
            'Name', user.name,
            'Blood Group', user.bloodgroup,
            'Father Name', user.fathername,
            'Mother Name', user.mothername,
            'Aadhar Number', user.adhar,
            'Address', user.address,
            'Gender', user.gender,
            'Date of Birth', user.dob,
            'Occupation', user.occupation,
            'Grade', user.grade,
            'Parent Email', user.parentemail,
            'Roll Number', user.rollno,
            'Aim', user.placeofbirth, //POB  ->  AIM
            'Religion', user.religion,
            'Date of Admission', user.dateofadmission,
            'Previous Percentage', user.previouspercentage,
            'Mobile Number', user.mobilenumber,
            'User ID', user.userid,
            'School Registration ID', user.schoolregid,
          ],
        ),
      ),
    );
  }

  Widget String label, String value) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(4, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment,
        children: [
          Text(
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey, // Color for the label
            ),
          ),
          const SizedBox(height: 8),
          Text(
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
