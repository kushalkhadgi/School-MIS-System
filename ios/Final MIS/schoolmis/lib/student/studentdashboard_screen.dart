import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:schoolmis/student/videoscreen.dart';

import 'package:schoolmis/Drawer/ContactPage.dart';
import 'package:schoolmis/Drawer/DevelopersPage.dart';
import 'package:schoolmis/login/auth.dart';
import 'package:schoolmis/student/studymaterial_screen.dart';
import 'package:schoolmis/student/yojnaa_screen.dart';
import 'package:schoolmis/student/svpcet_updates.dart';
import 'package:schoolmis/student/achievement_screen.dart';
import 'package:schoolmis/student/contact_screen.dart';
import 'package:schoolmis/student/announcement_screen.dart';
import '../widgets/background_widget.dart';
import '../widgets/dashboard_item.dart';
import 'package:schoolmis/quote/quote_screen.dart';
import '../login/login.dart';
import 'profile_screen.dart';

class StudentdashboardScreen extends StatefulWidget {
  final Student student;

  const StudentdashboardScreen({
    super.key,
    required this.student,
  });

  @override
  _StudentdashboardScreenState createState() => _StudentdashboardScreenState();
}

class _StudentdashboardScreenState extends State<StudentdashboardScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    String name = widget.student.name.split(' ')[0];
    String aim = widget.student.placeofbirth.split(' ')[0];
    // String aim = widget.student.aim.split(' ')[0];
    // String aim = widget.student.aim;

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
                      return StudentdashboardScreen(student: widget.student);
                    }));
                    _advancedDrawerController.hideDrawer();
                  },
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return StudentProfilePage(user: widget.student);
                    }));
                    _advancedDrawerController.hideDrawer();
                  },
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return const DevelopersPage();
                    }));
                    _advancedDrawerController.hideDrawer();
                  },
                  leading: const Icon(Icons.favorite),
                  title: const Text('About us'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return const ContactPage();
                    }));
                    _advancedDrawerController.hideDrawer();
                  },
                  leading: const Icon(Icons.contact_mail),
                  title: const Text('Contact'),
                ),
                ListTile(
                  onTap: () {
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
          title: Text(
            'Hi ${name.toUpperCase()} ($aim)',
            style: const TextStyle(
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
                child: Text(
                  'Student Dashboard',
                  // aim != null ? 'Future Aim: $aim' : 'Student Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
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
                    imagePath: 'assets/dashboard/studymaterial.png',
                    title: 'Study Material',
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return const StudyMaterialScreen();
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
                  DashboardItem(
                    imagePath: 'assets/dashboard/announcement.png',
                    title: 'Announcement',
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return StudentAnnouncementScreen();
                      }));
                    },
                  ),
                  DashboardItem(
                    imagePath: 'assets/dashboard/yojnaa.png',
                    title: 'Yojnaa',
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return const StudentYojnaaScreen();
                      }));
                    },
                  ),
                  DashboardItem(
                    imagePath: 'assets/dashboard/achievement.png',
                    title: 'Achievement',
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return const FetchMessageScreen();
                      }));
                    },
                  ),
                  DashboardItem(
                    imagePath: 'assets/dashboard/contact.png',
                    title: 'Contact Teacher',
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return ContactScreen();
                      }));
                    },
                  ),
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
