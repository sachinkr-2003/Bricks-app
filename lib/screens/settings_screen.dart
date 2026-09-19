import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hr_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Light blue-grey background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A), // Dark slate match
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'PLATFORM SETTINGS',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 2.0,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dark Header Stats Card
            Container(
              width: double.infinity,
              color: const Color(0xFF0F172A),
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32, top: 16),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    color: const Color(0xFFEA580C),
                    child: const Icon(Icons.business, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MASTER CONTROL',
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8), letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'System Configuration',
                          style: GoogleFonts.merriweather(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            
            // Settings List
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SECURITY & PROFILE',
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsTile(
                    context,
                    'Account User Profile',
                    'Manage detailed personal info.',
                    Icons.person_outline,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  Text(
                    'ADMINISTRATIVE TOOLS',
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsTile(
                    context,
                    'Human & Resources',
                    'Manage site Labours & Vendors database.',
                    Icons.people_alt_outlined,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HRScreen()));
                    },
                  ),
                  _buildSettingsTile(context, 'Push Notifications', 'Configure alerts for mobile.', Icons.notifications_active_outlined),
                  
                  const SizedBox(height: 40),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                      },
                      icon: const Icon(Icons.logout),
                      label: Text('SIGN OUT SECURELY', style: GoogleFonts.inter(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, String title, String subtitle, IconData icon, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          color: const Color(0xFFF1F5F9),
          child: Icon(icon, color: const Color(0xFF0F172A), size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            subtitle,
            style: GoogleFonts.merriweather(
              fontSize: 11,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
      ),
    );
  }
}
