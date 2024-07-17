import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoolmis/teacher/studentdetails_screen.dart';
import 'package:intl/intl.dart'; 

class EditProfileScreen extends StatelessWidget {
  final String studentName;
  final String email;
  final String bloodGroup;
  final String fathername;
  final String mothername;
  final String adhar;
  final String address;
  final String gender;
  final String dob;
  final String occupation;
  final String grade;
  final String parentemail;
  final String rollno;
  final String aim;
  final String religion;
  final String dateofadmission;
  final String previouspercentage;
  final String mobilenumber;
  final String userid;
  final String schoolregid;

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _fathernameController;
  late TextEditingController _mothernameController;
  late TextEditingController _adharController;
  late TextEditingController _addressController;
  late TextEditingController _genderController;
  late TextEditingController _dobController;
  late TextEditingController _occupationController;
  late TextEditingController _gradeController;
  late TextEditingController _parentemailController;
  late TextEditingController _rollnoController;
  late TextEditingController _aimController;
  late TextEditingController _religionController;
  late TextEditingController _dateofadmissionController;
  late TextEditingController _previouspercentageController;
  late TextEditingController _mobilenumberController;
  late TextEditingController _useridController;
  late TextEditingController _schoolregidController;


  void initState() {
    super.initState();
    _nameController = TextEditingController(text: studentName);
    _emailController = TextEditingController(text: email);
    _bloodGroupController = TextEditingController(text: bloodGroup);
    _fathernameController = TextEditingController(text: fathername);
    _mothernameController = TextEditingController(text: mothername);
    _adharController = TextEditingController(text: adhar);
    _addressController = TextEditingController(text: address);
    _genderController = TextEditingController(text: gender);
    _dobController = TextEditingController(text: dob);
    _occupationController = TextEditingController(text: occupation);
    _gradeController = TextEditingController(text: grade);
    _parentemailController = TextEditingController(text: parentemail);
    _rollnoController = TextEditingController(text: rollno);

    _aimController = TextEditingController(text: aim);
    _religionController = TextEditingController(text: religion);
    _dateofadmissionController =
        TextEditingController(text: dateofadmission);
    _previouspercentageController =
        TextEditingController(text: previouspercentage);
    _mobilenumberController = TextEditingController(text: mobilenumber);
    _useridController = TextEditingController(text: userid);
    _schoolregidController = TextEditingController(text: schoolregid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
            // fontWeight: FontWeight.bold, // Adjust the font weight if needed
          ),
        ),
        backgroundColor: Colors.deepPurple, // Change the color of the AppBar
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(' Name:'),
              TextFormField(
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              const Text(' Email:'),
              TextFormField(
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              const Text(' Blood Group:'),
              TextFormField(
                controller: _bloodGroupController,
              ),
              const SizedBox(height: 20),
              const Text(' Father Name:'),
              TextFormField(
                controller: _fathernameController,
              ),
              const SizedBox(height: 20),
              const Text(' Mother Name:'),
              TextFormField(
                controller: _mothernameController,
              ),
              const SizedBox(height: 20),
              const Text(' Adhar Number:'),
              TextFormField(
                controller: _adharController,
              ),
              const SizedBox(height: 20),
              const Text(' Address:'),
              TextFormField(
                controller: _addressController,
              ),
              const SizedBox(height: 20),
              const Text(' Gender:'),
              TextFormField(
                controller: _genderController,
              ),
              const SizedBox(height: 20),
              const Text(' Date of Birth:'),
              TextFormField(
                controller: _dobController,
                readOnly: false,
                onTap: () => _selectDate(context, Text),
              ),
              const SizedBox(height: 20),
              const Text(' Occupation:'),
              TextFormField(
                controller: _occupationController,
              ),
              const SizedBox(height: 20),
              const Text(' Grade:'),
              TextFormField(
                controller: _gradeController,
              ),
              const SizedBox(height: 20),
              const Text(' Parent Email:'),
              TextFormField(
                controller: _parentemailController,
              ),
              const SizedBox(height: 20),
              const Text(' Roll Number:'),
              TextFormField(
                controller: _rollnoController,
              ),
              const SizedBox(height: 20),
              const Text('Aim:'), //POB  ->  AIM
              TextFormField(
                controller: _aimController,
              ),
              const SizedBox(height: 20),
              const Text('Religion:'),
              TextFormField(
                controller: _religionController,
              ),
              const SizedBox(height: 20),
              const Text('Date of Admission:'),
              TextFormField(
                controller: _dateofadmissionController,
                readOnly: true,
                onTap: () => _selectDate(context, _dateofadmissionController),
              ),
              const SizedBox(height: 20),
              const Text('Previous Percentage:'),
              TextFormField(
                controller: _previouspercentageController,
              ),
              const SizedBox(height: 20),
              const Text('Mobile Number:'),
              TextFormField(
                controller: _mobilenumberController,
              ),
              const SizedBox(height: 20),
              const Text('User ID:'),
              TextFormField(
                controller: _useridController,
              ),
              const SizedBox(height: 20),
              const Text('School Registration ID:'),
              TextFormField(
                controller: _schoolregidController,
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed(
                          _saveProfileChanges, 'Profile Saved Sucessfully'),
                      child: const Text('Save Profile'),
                    ),
                    ElevatedButton(
                      onPressed (
                          _handleAction(_deleteProfile, 'Profile deleted'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 245, 196, 191)),
                      child: const Text('Delete Profile'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime currentDate = DateTime.Today();
    DateTime? selectedDate = showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate == null || selectedDate == currentDate) {
      controller.text = _dateFormat.format(selectedDate);
    }
  }

  void _deleteProfile() {
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: studentName)
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.delete();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StudentDetailScreen()),
        );
      }
    });
  }

  void _handleAction(Function action, String message) {
    action();

    // Show a SnackBar to indicate the completion of the action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2000),
      ),
    );
  }

  void _saveProfileChanges() {
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: studentName)
        .get()
        .then((QuerySnapshot querySnapshot) {
    });
  }
}
