import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _user;
  bool _isLoading = true;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final res = await ApiService().getData('/auth/profile');
    if (res['success'] && mounted) {
      setState(() {
        _user = res['data'];
        _isLoading = false;
      });
      // Update local storage just in case
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(_user));
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() => _isUploading = true);

      // 1. Upload the image to get URL
      final uploadRes = await ApiService().uploadImages([image.path]);
      if (uploadRes['success'] && uploadRes['urls'].length > 0) {
        final imageUrl = uploadRes['urls'][0];
        
        // 2. Update backend profile
        final updateRes = await ApiService().putData('/auth/profile', {'profileImage': imageUrl});
        if (updateRes['success'] && mounted) {
          setState(() {
            _user = updateRes['data'];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile image updated!'), backgroundColor: Colors.green),
          );
        }
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(child: CircularProgressIndicator(color: Color(0xFFEA580C))),
      );
    }

    final name = _user?['name'] ?? 'Unknown User';
    final role = (_user?['role'] ?? 'Client').toString().toUpperCase();
    final profileImage = _user?['profileImage'];
    final phone = _user?['phone'] ?? 'N/A';

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
                          child: profileImage != null && profileImage.isNotEmpty
                              ? Image.network(profileImage, fit: BoxFit.cover)
                              : const Icon(Icons.person, color: Colors.white, size: 48),
                        ),
                      ),
                      Positioned(
                        bottom: -4,
                        right: -4,
                        child: GestureDetector(
                          onTap: _isUploading ? null : _pickAndUploadImage,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEA580C),
                              border: Border.all(color: const Color(0xFF0F172A), width: 3),
                            ),
                            child: _isUploading
                                ? const Padding(padding: EdgeInsets.all(6), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    name,
                    style: GoogleFonts.merriweather(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green.shade900.withOpacity(0.5), border: Border.all(color: Colors.green.shade700)),
                    child: Text(
                      '$role ACCESS',
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
                          Text('1', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 24, color: const Color(0xFF0F172A))),
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
                          Text('✓', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 24, color: const Color(0xFFEA580C))),
                          const SizedBox(height: 4),
                          Text('SECURE LOGIN', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 9, color: const Color(0xFF64748B), letterSpacing: 1.0)),
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
                        _buildDetailRow('PHONE NUMBER', phone, Icons.phone_android, hasBorder: true),
                        _buildDetailRow('USER ROLE', role, Icons.shield, hasBorder: false),
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
        border: hasBorder ? const Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.5)) : null,
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
}
