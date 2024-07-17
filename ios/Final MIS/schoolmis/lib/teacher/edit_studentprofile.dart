import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoolmis/teacher/studentdetails_screen.dart';
import 'package:intl/intl.dart'; 

class EditProfileScreen extends StatefulWidget {
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

  const EditProfileScreen({
    super.key,
    required this.studentName,
    required this.email,
    required this.bloodGroup,
    required this.fathername,
    required this.mothername,
    required this.adhar,
    required this.address,
    required this.gender,
    required this.dob,
    required this.occupation,
    required this.grade,
    required this.parentemail,
    required this.rollno,
    required this.aim,
    required this.religion,
    required this.dateofadmission,
    required this.previouspercentage,
    required this.mobilenumber,
    required this.userid,
    required this.schoolregid,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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

  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.studentName);
    _emailController = TextEditingController(text: widget.email);
    _bloodGroupController = TextEditingController(text: widget.bloodGroup);
    _fathernameController = TextEditingController(text: widget.fathername);
    _mothernameController = TextEditingController(text: widget.mothername);
    _adharController = TextEditingController(text: widget.adhar);
    _addressController = TextEditingController(text: widget.address);
    _genderController = TextEditingController(text: widget.gender);
    _dobController = TextEditingController(text: widget.dob);
    _occupationController = TextEditingController(text: widget.occupation);
    _gradeController = TextEditingController(text: widget.grade);
    _parentemailController = TextEditingController(text: widget.parentemail);
    _rollnoController = TextEditingController(text: widget.rollno);

    _aimController = TextEditingController(text: widget.aim);
    _religionController = TextEditingController(text: widget.religion);
    _dateofadmissionController =
        TextEditingController(text: widget.dateofadmission);
    _previouspercentageController =
        TextEditingController(text: widget.previouspercentage);
    _mobilenumberController = TextEditingController(text: widget.mobilenumber);
    _useridController = TextEditingController(text: widget.userid);
    _schoolregidController = TextEditingController(text: widget.schoolregid);
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
                readOnly: true,
                onTap: () => _selectDate(context, _dobController),
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
                      onPressed: () => _handleAction(
                          _saveProfileChanges, 'Profile Saved Sucessfully'),
                      child: const Text('Save Profile'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
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
    DateTime currentDate = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null && selectedDate != currentDate) {
      controller.text = _dateFormat.format(selectedDate);
    }
  }

  void _deleteProfile() {
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: widget.studentName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StudentDetailScreen()),
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
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _saveProfileChanges() {
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: widget.studentName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({
          'name': _nameController.text,
          'email': _emailController.text,
          'bloodgroup': _bloodGroupController.text,
          'fathername': _fathernameController.text,
          'mothername': _mothernameController.text,
          'adhar': _adharController.text,
          'address': _addressController.text,
          'gender': _genderController.text,
          'dob': _dobController.text,
          'occupation': _occupationController.text,
          'grade': _gradeController.text,
          'parentemail': _parentemailController.text,
          'rollno': _rollnoController.text,
          'placeofbirth': _aimController.text,
          'religion': _religionController.text,
          'dateofadmission': _dateofadmissionController.text,
          'previouspercentage': _previouspercentageController.text,
          'mobilenumber': _mobilenumberController.text,
          'userid': _useridController.text,
          'schoolregid': _schoolregidController.text,
        });
        Navigator.pop(context);
      }
    });
  }
}
