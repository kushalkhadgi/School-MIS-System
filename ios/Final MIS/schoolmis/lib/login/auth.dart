import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  String name;
  String email;
  String bloodgroup;
  String fathername;
  String mothername;
  String adhar;
  String address;
  String gender;
  String dob;
  String occupation;
  String grade;
  String parentemail;
  String rollno;
  String placeofbirth;
  String religion;
  String caste;
  String dateofadmission;
  String previouspercentage;
  String mobilenumber;
  String userid;
  String schoolregid;
  Student(
      this.name,
      this.role,
      this.email,
      this.bloodgroup,
      this.fathername,
      this.mothername,
      this.adhar,
      this.address,
      this.gender,
      this.dob,
      this.occupation,
      this.grade,
      this.parentemail,
      this.rollno,
      this.placeofbirth,
      this.religion,
      this.caste,
      this.dateofadmission,
      this.previouspercentage,
      this.mobilenumber,
      this.userid,
      this.schoolregid);
  String role;
}

class Teacher {
  String name;
  String email;
  String bloodgroup;
  String fathername;
  String mothername;
  String adhar;
  String address;
  String gender;
  String dob;
  String occupation;
  String grade;
  String parentemail;
  String rollno;
  String placeofbirth;
  String religion;
  String caste;
  String dateofadmission;
  String previouspercentage;
  String mobilenumber;
  String userid;
  String schoolregid;
  Teacher(
      this.name,
      this.role,
      this.email,
      this.bloodgroup,
      this.fathername,
      this.mothername,
      this.adhar,
      this.address,
      this.gender,
      this.dob,
      this.occupation,
      this.grade,
      this.parentemail,
      this.rollno,
      this.placeofbirth, //used for aim
      this.religion,
      this.caste,
      this.dateofadmission,
      this.previouspercentage,
      this.mobilenumber,
      this.userid,
      this.schoolregid);
  String role;
}

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> register(
      {required bool isStudent,
      required String email,
      required String password,
      required String name,
      required String fathername,
      required String mothername,
      required String bloodgroup,
      required String adhar,
      required String address,
      required String gender,
      required String dob,
      required String occupation,
      required String grade,
      required String parentemail,
      required String rollno,
      required String placeofbirth, //used for aim
      required String religion,
      required String dateofadmission,
      required String previouspercentage,
      required String mobilenumber,
      required String userid,
      required String schoolregid}) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set the user's role in Firebase Firestore based on 'isStudent' parameter.
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'role': isStudent ? 'student' : 'teacher',
        'email': email,
        'name': name,
        'bloodgroup': bloodgroup,
        'fathername': fathername,
        'mothername': mothername,
        'adhar': adhar,
        'address': address,
        'gender': gender,
        'dob': dob,
        'occupation': occupation,
        'grade': grade,
        'parentemail': parentemail,
        'rollno': rollno,
        'placeofbirth': placeofbirth,
        'religion': religion,
        'dateofadmission': dateofadmission,
        'previouspercentage': previouspercentage,
        'mobilenumber': mobilenumber,
        'userid': userid,
        'schoolregid': schoolregid,
      });

      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Student?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        final userDoc = await _firestore
            .collection('users')
            .where('email', isEqualTo: userCredential.user!.email)
            .get();

        final userData = userDoc.docs[0].data();
        final userRole = userData['role'] as String;
        final name = userData['name'] as String;
        final email = userData['email'] as String;
        final bloodgroup = userData['bloodgroup'] as String;
        final fathername = userData['fathername'] as String;
        final mothername = userData['mothername'] as String;
        final adhar = userData['adhar'] as String;
        final address = userData['address'] as String;
        final gender = userData['gender'] as String;
        final dob = userData['dob'] as String;

        final occupation = userData['occupation'] as String;

        final grade = userData['grade'] as String;

        final parentemail = userData['parentemail'] as String;
        final rollno = userData['rollno'] as String;

        final placeofbirth = userData['placeofbirth'] as String;
        final religion = userData['religion'] as String;
        final caste = userData['caste'] as String;
        final dateofadmission = userData['dateofadmission'] as String;
        final previouspercentage = userData['previouspercentage'] as String;
        final mobilenumber = userData['mobilenumber'] as String;
        final userid = userData['userid'] as String;
        final schoolregid = userData['schoolregid'] as String;

        return Student(
            name,
            userRole,
            email,
            bloodgroup,
            fathername,
            mothername,
            adhar,
            address,
            gender,
            dob,
            occupation,
            grade,
            parentemail,
            rollno,
            placeofbirth,
            religion,
            caste,
            dateofadmission,
            previouspercentage,
            mobilenumber,
            userid,
            schoolregid);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> getUserRoleFromFirestore(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final userRole = userData['role'] as String;
        return userRole;
      } else {
        return 'unknown';
      }
    } catch (e) {
      print(e.toString());
      return 'unknown';
    }
  }
}
