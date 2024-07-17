import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoolmis/teacher/edit_studentprofile.dart';

class ProfileScreen extends StatefulWidget {
  final String studentName;

  const ProfileScreen();

  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.studentName);
    _emailController = TextEditingController();
    _bloodGroupController = TextEditingController();
    _fathernamecontroller = TextEditingController();
    _mothernameController = TextEditingController();
    _adharController = TextEditingController();
    _addressController = TextEditingController();
    _genderController = TextEditingController();
    _dobController = TextEditingController();
    _occupationController = TextEditingController();
    _gradeController = TextEditingController();
    _parentemailController = TextEditingController();
    _rollnoController = TextEditingController();
    _aimController = TextEditingController();
    _religionController = TextEditingController();
    _dateofadmissionController = TextEditingController();
    _previouspercentageController = TextEditingController();
    _mobilenumberController = TextEditingController();
    _useridController = TextEditingController();
    _schoolregidController = TextEditingController();

    _fetchAdditionalData();
  }

  void _fetchAdditionalData() {
    FirebaseFirestore.instance
        .where('name', isEqualTo: widget.studentName)
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _emailController.text = userData['email']  '';
          _bloodGroupController.text = userData['bloodgroup']  '';
          _fathernamecontroller.text = userData['fathername']  '';
          _mothernameController.text = userData['mothername']  '';
          _adharController.text = userData['adhar']  '';
          _addressController.text = userData['address']  '';
          _genderController.text = userData['gender']  '';
          _dobController.text = userData['dob']  '';
          _occupationController.text = userData['occupation']  '';
          _gradeController.text = userData['grade']  '';
          _parentemailController.text = userData['parentemail']  '';
          _rollnoController.text = userData['rollno']  '';
          _aimController.text = userData['placeofbirth']  ''; //POB  ->  AIM
          _religionController.text = userData['religion']  '';
          _dateofadmissionController.text = userData['dateofadmission']  '';
          _previouspercentageController.text =
              userData['previouspercentage']  '';
          _mobilenumberController.text = userData['mobilenumber']  '';
          _useridController.text = userData['userid']  '';
          _schoolregidController.text = userData['schoolregid']  '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
          ),
        ),
        backgroundColor: Colors.deepPurple, // Change the color of the AppBar
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildProfileDetailCard('Name', widget.studentName),
                buildProfileDetailCard('Email', _emailController.text),
                buildProfileDetailCard(
                    'Blood Group', _bloodGroupController.text),
                buildProfileDetailCard(
                    'Father Name', _fathernamecontroller.text),
                buildProfileDetailCard(
                    'Mother Name', _mothernameController.text),
                buildProfileDetailCard('Adhar Number', _adharController.text),
                buildProfileDetailCard('Address', _addressController.text),
                buildProfileDetailCard('Gender', _genderController.text),
                buildProfileDetailCard('Date of Birth', _dobController.text),
                buildProfileDetailCard(
                    'Occupation', _occupationController.text),
                buildProfileDetailCard('Class', _gradeController.text),
                buildProfileDetailCard(
                    'Parent Email', _parentemailController.text),
                buildProfileDetailCard('Roll Number', _rollnoController.text),
                buildProfileDetailCard(
                    'Aim', _aimController.text), //POB  -> AIM
                buildProfileDetailCard('Religion', _religionController.text),
                buildProfileDetailCard(
                    'Date of Admission', _dateofadmissionController.text),
                buildProfileDetailCard(
                    'Previous Percentage', _previouspercentageController.text),
                buildProfileDetailCard(
                    'Mobile Number', _mobilenumberController.text),
                buildProfileDetailCard('User ID', _useridController.text),
                buildProfileDetailCard(
                    'School Registration ID', _schoolregidController.text),
                const SizedBox(height: 16), // Add some spacing
                Center(
                  child: ElevatedButton(
                    onPressed: _navigateToEditProfile,
                    child: const Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileDetailCard(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            // color: const Color.fromARGB(255, 158, 158, 158).withOpacity(0.5),
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

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) (
          studentName: studentName,
          email: _emailController.text,
          bloodGroup: _bloodGroupController.text,
          fathername: _fathernamecontroller.text,
          mothername: _mothernameController.text,
          adhar: _adharController.text,
          address: _addressController.text,
          gender: _genderController.text,
          dob: _dobController.text,
          occupation: _occupationController.text,
          grade: _gradeController.text,
          parentemail: _parentemailController.text,
          rollno: _rollnoController.text,
          aim: _aimController.text,
          religion: _religionController.text,
          dateofadmission: _dateofadmissionController.text,
          previouspercentage: _previouspercentageController.text,
          mobilenumber: _mobilenumberController.text,
          userid: _useridController.text,
          schoolregid: _schoolregidController.text,
        ),
      ),
    );
  }
}
