import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/base/base_colors.dart' as baseColors;
import 'package:vas_reporting/screen/home/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Fullscreen + status bar transparent + icon hitam
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Header image
          Container(
            height: 280,
            width: double.infinity,
            color: baseColors.primaryColor,
          ),

          // Konten
          ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 60),
              // Avatar & nama
              Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage("https://picsum.photos/200"),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Miranda West",
                    style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Work hard in silence. Let your success be the noise.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Card menu
              _buildCard([
                _buildTile(Icons.location_on_outlined, "My Address"),
                _buildTile(Icons.person_outline, "Account"),
              ]),
              _buildCard([
                _buildTile(Icons.notifications_none, "Notifications"),
                _buildTile(Icons.devices_outlined, "Devices"),
                _buildTile(Icons.vpn_key_outlined, "Passwords"),
                _buildTile(Icons.language, "Language"),
              ]),
              const SizedBox(height: 20),
              TextButton(
                onPressed: (){
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (Route<dynamic> route) => false,
                    );
                }, 
                child: Text('Back to home', style: GoogleFonts.urbanist(color: baseColors.primaryColor))
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}
