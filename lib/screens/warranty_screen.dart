import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'form_screen.dart';

class WarrantyScreen extends StatelessWidget {
  const WarrantyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
        title: Text(
          'Warranty Hub',
          style: GoogleFonts.merriweather(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
              ),
              child: Column(
                children: [
                  const Icon(Icons.verified_user, color: Color(0xFFEA580C), size: 48),
                  const SizedBox(height: 16),
                  Text(
                    '11-Year Guarantee',
                    style: GoogleFonts.merriweather(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  const Text('ACTIVE STRUCTURAL WARRANTY', style: TextStyle(color: Color(0xFFFBA11B), fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text('START DATE', style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text('01 Jan 2027', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(width: 1, height: 30, color: const Color(0xFF334155)),
                      Column(
                        children: [
                          const Text('END DATE', style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text('01 Jan 2038', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FormScreen(title: 'Lodge Complaint')),
                  );
                },
                icon: const Icon(Icons.support_agent),
                label: const Text('LODGE A COMPLAINT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEA580C),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('WARRANTY COVERAGE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), letterSpacing: 1)),
                  const Divider(color: Color(0xFFE2E8F0), height: 24),
                  _buildCoverageRow('Structural Integrity', 'Cracks in beams or main walls.'),
                  const SizedBox(height: 12),
                  _buildCoverageRow('Seepage & Leakage', 'Water seepage from internal plumbing (First 5 years).'),
                  const SizedBox(height: 12),
                  _buildCoverageRow('Electrical Systems', 'Major failure in primary concealed wiring.'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCoverageRow(String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, size: 16, color: Colors.green),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
              const SizedBox(height: 2),
              Text(desc, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            ],
          ),
        ),
      ],
    );
  }
}
