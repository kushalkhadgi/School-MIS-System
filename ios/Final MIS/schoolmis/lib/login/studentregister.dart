import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolmis/login/auth.dart';
import 'package:intl/intl.dart';

class StudentRegisterPage extends StatelessWidget {
  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> gradeOptions =
      List.generate(10, (index) => (index + 1).toString());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bloodgroupController = TextEditingController();
  final TextEditingController fathernameController = TextEditingController();
  final TextEditingController mothernameController = TextEditingController();

  final TextEditingController adharController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController parentemailController = TextEditingController();
  final TextEditingController rollnoController = TextEditingController();
  final TextEditingController aimController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController dateofadmissionController =
      TextEditingController();
  final TextEditingController previouspercentageController =
      TextEditingController();
  final TextEditingController mobilenumberController = TextEditingController();
  final TextEditingController useridController = TextEditingController(); //
  final TextEditingController schoolregidController =
      TextEditingController(); //
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  StudentRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildTextField(context, emailController, 'Email *',
                isEmailField: true),
            buildTextField(context, passwordController, 'Password *',
                obscureText: true),
            buildTextField(context, nameController, 'Name *'),
            buildBloodGroupField(context),
            buildTextField(context, fathernameController, 'Father\'s Name *'),
            buildTextField(context, mothernameController, 'Mother\'s Name *'),
            buildTextField(context, adharController, 'Adhar Number *'),
            buildTextField(context, addressController, 'Address *'),
            buildTextField(context, dobController, 'Date of Birth *',
                readOnly: true, isDateField: true),
            buildTextField(context, occupationController, 'Occupation'),
            buildGradeField(context),
            buildTextField(context, parentemailController, 'Parent Email *'),
            buildTextField(context, rollnoController, 'Roll No *'),
            buildTextField(
                context, aimController, 'Aim *'), //      POB  ->  AIM
            buildTextField(context, religionController, 'Religion *'),
            buildTextField(
                context, dateofadmissionController, 'Date of Admission *',
                readOnly: true, isDateField: true),
            buildTextField(
                context, previouspercentageController, 'Previous Percentage *'),
            buildTextField(context, mobilenumberController, 'Mobile Number *'),
            buildTextField(context, useridController, 'User ID'),
            buildTextField(
                context, schoolregidController, 'School Registration ID'),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.deepPurple, // Use backgroundColor instead of primary
                foregroundColor: Colors.white,
                shadowColor: Colors.deepPurpleAccent,
                elevation: 5,
              ),
              onPressed: () async {
                if (validateFields(context)) {
                  final email = emailController.text;
                  final password = passwordController.text;
                  final name = nameController.text;
                  final bloodgroup = bloodgroupController.text;
                  final fathername = fathernameController.text;
                  final mothername = mothernameController.text;
                  final adhar = adharController.text;
                  final address = addressController.text;
                  final gender = genderController.text;
                  final dob = dobController.text;
                  final occupation = occupationController.text;
                  final grade = gradeController.text;
                  final parentemail = parentemailController.text;
                  final rollno = rollnoController.text;
                  final aim = aimController.text;
                  final religion = religionController.text;
                  final dateofadmission = dateofadmissionController.text;
                  final previouspercentage = previouspercentageController.text;
                  final mobilenumber = mobilenumberController.text;
                  final userid = useridController.text;
                  final schoolregid = schoolregidController.text;

                  final user = await auth.register(
                    email: email,
                    password: password,
                    name: name,
                    bloodgroup: bloodgroup,
                    fathername: fathername,
                    mothername: mothername,
                    adhar: adhar,
                    address: address,
                    gender: gender,
                    dob: dob,
                    occupation: occupation,
                    grade: grade,
                    parentemail: parentemail,
                    rollno: rollno,
                    placeofbirth: aim,
                    religion: religion,
                    dateofadmission: dateofadmission,
                    previouspercentage: previouspercentage,
                    mobilenumber: mobilenumber,
                    userid: userid,
                    schoolregid: schoolregid,
                    isStudent: true,
                  );
                  if (user != null) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Register as Student'),
            ),
          ],
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

  Widget buildTextField(
    BuildContext context,
    TextEditingController controller,
    String labelText, {
    bool obscureText = false,
    bool readOnly = false,
    bool isDateField = false,
    bool isEmailField = false,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        onTap: isDateField ? () => _selectDate(context, controller) : null,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          } else if (isEmailField && !value.contains('@')) {
            return 'Enter a valid email address';
          }
          return null; // Return null if the validation succeeds
        },
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          labelStyle: const TextStyle(color: Colors.deepPurple),
          focusColor: Colors.deepPurple,
          hoverColor: Colors.deepPurple,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          isDense: true,
          errorStyle: const TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget buildGradeField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: gradeController.text.isNotEmpty ? gradeController.text : null,
        onChanged: (String? newValue) {
          gradeController.text = newValue ?? '';
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a grade';
          }
          return null;
        },
        items: gradeOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: 'Grade *',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          labelStyle: const TextStyle(color: Colors.deepPurple),
          focusColor: Colors.deepPurple,
          hoverColor: Colors.deepPurple,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          isDense: true,
          errorStyle: const TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget buildGenderField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: genderController.text.isNotEmpty ? genderController.text : null,
        onChanged: (String? newValue) {
          genderController.text = newValue ?? '';
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a gender';
          }
          return null;
        },
        items: genderOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: 'Gender *',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          labelStyle: const TextStyle(color: Colors.deepPurple),
          focusColor: Colors.deepPurple,
          hoverColor: Colors.deepPurple,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          isDense: true,
          errorStyle: const TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget buildBloodGroupField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: bloodgroupController.text.isNotEmpty
            ? bloodgroupController.text
            : null,
        onChanged: (String? newValue) {
          bloodgroupController.text = newValue ?? '';
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a blood group';
          }
          return null;
        },
        items: bloodGroups.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: 'Blood Group *',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          labelStyle: const TextStyle(color: Colors.deepPurple),
          focusColor: Colors.deepPurple,
          hoverColor: Colors.deepPurple,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          isDense: true,
          errorStyle: const TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }

  bool validateFields(BuildContext context) {
    final controllers = [
      emailController,
      passwordController,
      nameController,
      bloodgroupController,
      fathernameController,
      mothernameController,
      adharController,
      addressController,
      genderController,
      dobController,
      gradeController,
      parentemailController,
      rollnoController,
      aimController,
      religionController,
      dateofadmissionController,
      previouspercentageController,
      mobilenumberController,
    ];

    final numParameters = [
      adharController,
      rollnoController,
      previouspercentageController,
      mobilenumberController,
      useridController,
      schoolregidController
    ];

    for (final controller in controllers) {
      if (controller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all the required fields'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }

    for (final parameter in numParameters) {
      if (double.tryParse(parameter.text) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid number in required fields'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }

    if (mobilenumberController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a valid phone number'),
        backgroundColor: Colors.red,
      ));
    }

    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a valid email address'),
        backgroundColor: Colors.red,
      ));
      return false;
    }
    // Add more validations for other fields if needed
    else if (parentemailController.text.isEmpty ||
        !parentemailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a valid email address'),
        backgroundColor: Colors.red,
      ));
      return false;
    }
    if (RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(adharController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a valid Aadhaar Number'),
        backgroundColor: Colors.red,
      ));
      return false;
    }
    return true;
  }
}
