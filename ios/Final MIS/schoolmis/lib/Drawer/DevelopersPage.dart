import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DevelopersPage extends StatelessWidget {
  const DevelopersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: const Text('About Us',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
          ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildCard(
              'SVPCET',
              'St. Vincent Pallotti College of Engineering and Technology was established in 2004 by the Nagpur Pallottine Society. The College is accredited by NAAC with A grade. The College is affiliated to Nagpur University approved by Director of Technical Education, Mumbai and AICTE, Government of India',
              Colors.blue,
              'assets/drawer/svpcet.jpeg',
              largerImage: true,
              teamMembers: [],
            ),
            const SizedBox(height: 20),
            buildCard(
              'DEPARTMENT OF INFORMATION TECHNOLOGY',
              'To be a center of excellence in the domain of Information Technology to nurture future professionals. To impart computing knowledge in the field of information technology and emerging domains and to provide an effective learning environment for developing future technocrats with professional ethos and attitude for lifelong learning.',
              Colors.orange,
              'assets/drawer/college_logo.png',
              teamMembers: [],
            ),
            const SizedBox(height: 20),
            buildCard(
              'MEET OUR TEAM',
              'Mentored by: Information Technology Department\n\nDr. Manoj Bramhe \n\nProf. Priti Golar \n\nDeveloped by: ',
              const Color.fromARGB(255, 120, 31, 136),
              '',
              teamMembers: [
                TeamMember('Ishan Sathwane',
                    'https://www.linkedin.com/in/ishan-s-067162235/'),
                TeamMember('Kushal Khadgi',
                    'https://www.linkedin.com/in/kushal-khadgi-400764216/?originalSubdomain=in'),
                TeamMember('Nakul Wanjari',
                    'https://www.linkedin.com/in/nakul-wanjari-3a0b8a226/'),
                TeamMember('Mohit Bandawar',
                    'https://in.linkedin.com/in/mohit-bandawar-8403391ab'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(
    String title,
    String content,
    Color color,
    String imagePath, {
    bool largerImage = false,
    required List<TeamMember> teamMembers,
  }) {
    return AnimatedContainer(
      duration: const Duration(seconds: 4),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 240, 153, 255),
            Color.fromARGB(255, 255, 246, 166)
          ], // Replace with your gradient colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0], // Add gradient stops
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imagePath.isNotEmpty)
            SizedBox(
              height: largerImage ? 150 : 50,
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  _launchURL('https://www.stvincentngp.edu.in/');
                },
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 10),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          if (teamMembers.isNotEmpty)
            ...teamMembers.map((member) => buildTeamMember(member)),
        ],
      ),
    );
  }

  Widget buildTeamMember(TeamMember member) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () {
          // Add logic to navigate to the respective LinkedIn profile
          print('Navigate to ${member.profileLink}');
        },
        child: Row(
          children: [
            const Icon(Icons.mail),
            const SizedBox(width: 8),
            Text(
              member.name,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamMember {
  final String name;
  final String profileLink;

  TeamMember(this.name, this.profileLink);
}

void _launchURL(String url) async {
  try {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  } catch (e) {
    print('Error launching URL: $e');
  }
}
