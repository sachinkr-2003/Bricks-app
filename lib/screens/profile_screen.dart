import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Light background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'USER PROFILE',
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
            // Dark Banner Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 32, top: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        color: const Color(0xFFEA580C),
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          color: const Color(0xFF0F172A),
                          child: const Icon(Icons.person, color: Colors.white, size: 48),
                        ),
                      ),
                      Positioned(
                        bottom: -4,
                        right: -4,
                        child: GestureDetector(
                          onTap: () {
                            // Trigger image picker logic here in the future
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEA580C),
                              border: Border.all(color: const Color(0xFF0F172A), width: 3),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Rajesh Gupta',
                    style: GoogleFonts.merriweather(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green.shade900.withOpacity(0.5), border: Border.all(color: Colors.green.shade700)),
                    child: Text(
                      'ACTIVE PROPERTIES OWNER',
                      style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.greenAccent, letterSpacing: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            
            // Stats Row
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFCBD5E1), width: 1.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: const BoxDecoration(border: Border(right: BorderSide(color: Color(0xFFE2E8F0), width: 1.5))),
                      child: Column(
                        children: [
                          Text('2', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 24, color: const Color(0xFF0F172A))),
                          const SizedBox(height: 4),
                          Text('ACTIVE SITES', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 9, color: const Color(0xFF64748B), letterSpacing: 1.0)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Text('Oct 2024', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 24, color: const Color(0xFFEA580C))),
                          const SizedBox(height: 4),
                          Text('MEMBER SINCE', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 9, color: const Color(0xFF64748B), letterSpacing: 1.0)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CONTACT & PROJECT BINDINGS', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 1.5)),
                  const SizedBox(height: 12),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('PHONE NUMBER', '+91 9876543210', Icons.phone_android, hasBorder: true),
                        _buildDetailRow('EMAIL ADDRESS', 'rajesh.gupta@email.com', Icons.mail_outline, hasBorder: true),
                        _buildDetailRow('SITE ID', 'PRJ-1049-DLF', Icons.architecture, hasBorder: false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, {required bool hasBorder}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: hasBorder ? Border(bottom: BorderSide(color: const Color(0xFFE2E8F0), width: 1.5)) : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF94A3B8), size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8), letterSpacing: 1.0),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
              ),
            ],
          ),
        ],
      ),
    );
  }
} // Custom color definition override due to flutter Colors.slate not existing, wait flutter does not have Colors.slate.
