import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Slight slate background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
        title: Row(
          children: [
            // Using the company logo here instead of the default icon
            SizedBox(
              width: 28,
              height: 28,
              child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            Text(
              'BRICK BY BRICK',
              style: GoogleFonts.inter(
                color: const Color(0xFF0F172A),
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Badge(
              backgroundColor: Color(0xFFEA580C),
              smallSize: 8,
              child: Icon(Icons.notifications_none, color: Color(0xFF0F172A)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // MAIN HIGHLIGHT: PROJECT METRIC
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A), // Dark Classic Slate
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PROJECT PROGRESS',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF94A3B8),
                          letterSpacing: 2.0,
                        ),
                      ),
                      const Icon(Icons.show_chart, color: Color(0xFFEA580C), size: 20),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '65%',
                    style: GoogleFonts.inter(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.0,
                      letterSpacing: -2.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ROOF SLAB STAGE',
                    style: GoogleFonts.merriweather(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFCBD5E1),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Clean Line Progress Bar
                  Stack(
                    children: [
                      Container(height: 4, width: double.infinity, color: const Color(0xFF334155)),
                      Container(height: 4, width: 220, color: const Color(0xFFEA580C)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('45 DAYS ACTIVE', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8))),
                      Text('75 DAYS REMAINING', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8))),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TODAY'S SNAPSHOT (GRID INSTEAD OF TEXT)
            Row(
              children: [
                const Icon(Icons.today, size: 16, color: Color(0xFF0F172A)),
                const SizedBox(width: 8),
                Text(
                  "TODAY'S SNAPSHOT",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildDataWidget(title: 'TODAY EXPENSE', dataValue: '₹41k', bottomText: '+2 bills uploaded', icon: Icons.account_balance_wallet_outlined, highlight: true),
                _buildDataWidget(title: 'LABOUR ON SITE', dataValue: '04', bottomText: 'Workers Logged', icon: Icons.groups_outlined, highlight: false),
                _buildDataWidget(title: 'MATERIAL RECVD', dataValue: '45', bottomText: 'Bags of Cement', icon: Icons.inventory_2_outlined, highlight: false),
                _buildDataWidget(title: 'WORK STATUS', dataValue: 'Slab', bottomText: 'Shuttering done', icon: Icons.engineering_outlined, highlight: false),
              ],
            ),

            const SizedBox(height: 28),

            // QUICK ACTIONS
            Row(
              children: [
                const Icon(Icons.bolt, size: 16, color: Color(0xFF0F172A)),
                const SizedBox(width: 8),
                Text('QUICK ACTIONS', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A), letterSpacing: 1.5)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _buildQuickAction(Icons.add_photo_alternate_outlined, 'Add Bill'),
                const SizedBox(width: 12),
                _buildQuickAction(Icons.person_add_outlined, 'Add Labour'),
                const SizedBox(width: 12),
                _buildQuickAction(Icons.inventory_outlined, 'Material'),
                const SizedBox(width: 12),
                _buildQuickAction(Icons.note_add_outlined, 'Update'),
              ],
            ),

            const SizedBox(height: 28),

            // RECENT ACTIVITY
            Row(
              children: [
                const Icon(Icons.history, size: 16, color: Color(0xFF0F172A)),
                const SizedBox(width: 8),
                Text('RECENT ACTIVITY', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A), letterSpacing: 1.5)),
              ],
            ),
            const SizedBox(height: 14),
            _buildActivityItem(Icons.receipt_long_outlined, 'Bill Uploaded', 'Steel rods — ₹18,500', '2 hrs ago', const Color(0xFFEA580C)),
            _buildActivityItem(Icons.groups_outlined, 'Labour Update', '4 workers checked in', 'Today, 8:30 AM', const Color(0xFF0EA5E9)),
            _buildActivityItem(Icons.inventory_2_outlined, 'Material Received', '45 bags of cement', 'Today, 10:00 AM', const Color(0xFF10B981)),
            _buildActivityItem(Icons.construction_outlined, 'Work Log', 'Shuttering completed — Slab', 'Yesterday', const Color(0xFF8B5CF6)),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF0F172A), size: 22),
            const SizedBox(height: 6),
            Text(label, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 0.5), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, String title, String subtitle, String time, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400, color: const Color(0xFF64748B))),
              ],
            ),
          ),
          Text(time, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600, color: const Color(0xFF94A3B8))),
        ],
      ),
    );
  }


  Widget _buildDataWidget({
    required String title,
    required String dataValue,
    required String bottomText,
    required IconData icon,
    required bool highlight,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: highlight ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0), 
          width: highlight ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: highlight ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                  letterSpacing: 1.0,
                ),
              ),
              Icon(icon, size: 16, color: highlight ? const Color(0xFFEA580C) : const Color(0xFF94A3B8)),
            ],
          ),
          
          Text(
            dataValue,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
              letterSpacing: -1.0,
              height: 1.2,
            ),
          ),
          
          Text(
            bottomText,
            style: GoogleFonts.merriweather(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF64748B),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
