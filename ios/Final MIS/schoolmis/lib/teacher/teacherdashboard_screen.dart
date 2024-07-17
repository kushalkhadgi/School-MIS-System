import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:schoolmis/Drawer/ContactPage.dart';
import 'package:schoolmis/Drawer/DevelopersPage.dart';
import 'package:schoolmis/quote/quote_screen.dart';
import 'package:schoolmis/teacher/add_attendance.dart';
import 'package:schoolmis/teacher/announcement_screen.dart';
import 'package:schoolmis/teacher/studentdetails_screen.dart';
import 'package:schoolmis/teacher/studymaterial_screen.dart';
import 'package:schoolmis/teacher/videoscreen.dart';
import 'package:schoolmis/teacher/yojnaa.dart';
import 'package:schoolmis/student/svpcet_updates.dart';
import '../login/login.dart';
import '../login/register.dart';
import '../widgets/background_widget.dart';
import '../widgets/dashboard_item.dart';
import 'achievement.dart';

class TeacherdashboardScreen extends StatefulWidget {
  const TeacherdashboardScreen({super.key});

  @override
  _TeacherdashboardScreenState createState() => _TeacherdashboardScreenState();
}

class _TeacherdashboardScreenState extends State<TeacherdashboardScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 183, 83, 255),
              const Color.fromARGB(255, 246, 255, 80).withOpacity(0.2),
            ],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInSine,
      animationDuration: const Duration(milliseconds: 300),
      childDecoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: const Color.fromARGB(255, 0, 0, 0),
            iconColor: const Color.fromARGB(255, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/drawer/boyy.png',
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return const TeacherdashboardScreen(); // Replace ContactPage with the actual name of your Contact page widget
                    }));
                    _advancedDrawerController.hideDrawer();
                  },
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return const DevelopersPage(); // Replace ContactPage with the actual name of your Contact page widget
                    }));
                    _advancedDrawerController.hideDrawer();
                  },
                  leading: const Icon(Icons.favorite),
                  title: const Text('About us'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return const ContactPage(); // Replace ContactPage with the actual name of your Contact page widget
                    }));
                    _advancedDrawerController.hideDrawer();
                  },
                  leading: const Icon(Icons.contact_mail),
                  title: const Text('Contact'),
                ),
                ListTile(
                  onTap: () {
                    // Add logic for 'Log out'
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) {
                        return const LoginPage();
                      }),
                    );
                  },
                  leading: const Icon(Icons.logout_sharp),
                  title: const Text('Log out'),
                ),
                const Spacer(),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: const Text('Terms of Service | Privacy Policy'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Hi Teacher',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: BackgroundWidget(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const QuoteScreen(),
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Teacher Dashboard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  DashboardItem(
                    imagePath: 'assets/dashboard/studentdetails.png',
                    title: 'Student Details',
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return const StudentDetailScreen();
                      }));
                    },
                  ),
                  DashboardItem(
                    imagePath: 'assets/dashboard/attendance.jpg',
                    title: 'Attendance',
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return const AttendenceScreen();
                      }));
                    },
                  ),
                  DashboardItem(
                    imagePath: 'assets/dashboard/studymaterial.png',
                    title: 'Studymaterial',
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return const StudyMaterialScreen();
                      }));
                    },
                  ),
                  DashboardItem(
                    imagePath: 'assets/dashboard/announcement.png',
                    title: 'Announcement',
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return const TeacherAnnouncementScreen();
                      }));
                    },
                  ),
                  DashboardItem(
                    imagePath: 'assets/dashboard/yojnaa.png',
                    title: 'YOJNAA',
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return const TeacherYojnaaScreen();
                      }));
                    },
                  ),
                  DashboardItem(
                    imagePath: 'assets/dashboard/register.png',
                    title: 'Registration',
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return const Register();
                      }));
                    },
                  ),
                  DashboardItem(
                    imagePath: 'assets/dashboard/achievement.png',
                    title: 'Achievemnt',
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return const SendMessageScreen();
                      }));
                    },
                  ),
                  DashboardItem(
                    imagePath: 'assets/dashboard/studentresult.png',
                    title: 'SVPCET Updates',
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return const CollegeupdatesPage();
                      }));
                    },
                  ),
//    SizedBox(
//   width: double,
//   child: DashboardItem(
//     imagePath: '',
//     title: 'Upload Quiz',
//     onTap: () {
//       Navigator.of(context).push(MaterialPageRoute(builder: (_) {
//         return ClassTestPage();
//       }));
//     },
//   ),
// ),




                ],
              ),

              const VideoScreen(), // Recommended videos slider
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}
