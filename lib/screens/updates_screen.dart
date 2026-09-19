import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
        title: Text(
          'Daily / Weekly Updates',
          style: GoogleFonts.merriweather(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildUpdateCard(
            date: '19 Sep 2026',
            type: 'DAILY UPDATE',
            completed: 'Completed wooden shuttering for ground floor hall.',
            inProgress: 'Steel mesh binding is 50% done.',
            nextPlan: 'Complete steel binding to pour concrete tomorrow.',
            issues: 'None',
            hasPhotos: true,
          ),
          const SizedBox(height: 16),
          _buildUpdateCard(
            date: '12 Sep 2026',
            type: 'WEEKLY UPDATE',
            completed: 'All brickwork for ground floor walls finished.',
            inProgress: 'Plumbing rough-ins in bathrooms.',
            nextPlan: 'Start shuttering process next week.',
            issues: 'Slight delay in plumbing pipes delivery.',
            hasPhotos: false,
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateCard({
    required String date,
    required String type,
    required String completed,
    required String inProgress,
    required String nextPlan,
    required String issues,
    required bool hasPhotos,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFF8FAFC),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: GoogleFonts.merriweather(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF0F172A)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: const Color(0xFF0F172A),
                  child: Text(
                    type,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildField('WORK COMPLETED', completed, Icons.check_circle, Colors.green),
                const SizedBox(height: 12),
                _buildField('IN PROGRESS', inProgress, Icons.loop, Colors.blue),
                const SizedBox(height: 12),
                _buildField('NEXT PLANNED', nextPlan, Icons.trending_flat, const Color(0xFF94A3B8)),
                const SizedBox(height: 12),
                _buildField('ISSUES / DELAYS', issues, Icons.warning_rounded, issues != 'None' ? Colors.red : const Color(0xFF94A3B8)),
              ],
            ),
          ),
          
          if (hasPhotos)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE2E8F0)))),
              child: Row(
                children: [
                  const Icon(Icons.photo_library, size: 20, color: Color(0xFFEA580C)),
                  const SizedBox(width: 8),
                  const Text('3 Photos Uploaded', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 13)),
                  const Spacer(),
                  Text('VIEW PHOTOS', style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xFFEA580C), fontSize: 11, letterSpacing: 0.5)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildField(String title, String desc, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
              const SizedBox(height: 2),
              Text(desc, style: const TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
