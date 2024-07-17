import 'package:flutter/material.dart';

import 'package:schoolmis/teacher/Attendence_Viewer.dart';
import 'package:schoolmis/teacher/student_selection.dart';

// import 'package:pdf_flutter/pdf_flutter.dart';

//Select Grade(Class) of student
class AttendenceScreen extends StatelessWidget {
  const AttendenceScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance',
        style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
          ),
        ),
        backgroundColor: Colors.deepPurple, // Change the color of the AppBar
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Show the dialog to select the grade
                _showGradeSelectionDialog(context);
              },
              child: const Text('Select Grade and Continue'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the PDF list screen
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AttendanceViewer()));
              },
              child: const Text('View PDF List'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the grade selection dialog
  Future<void> _showGradeSelectionDialog(BuildContext context) {
    String selectedGrade; // Default grade

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Grade'),
          content: DropdownButtonFormField<String>(
            value: selectedGrade,
            onChanged: (String newValue) {
              selectedGrade = newValue!;
            },
            items: List.generate(
              10,
              (index) => DropdownMenuItem(
                value: (index + 1).toString(),
                child: Text('Grade index + 1'),
              ),
            ),
          ),
        );
      },
    );
  }

  // Function to navigate to StudentSelectionScreen
  void _navigateToStudentSelection(BuildContext context, String selectedGrade) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return StudentSelectionScreen(selectedGrade: selectedGrade);
        },
      ),
    );
  }
}



