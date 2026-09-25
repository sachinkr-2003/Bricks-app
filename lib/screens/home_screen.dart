import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hr_screen.dart';
import 'materials_screen.dart';
import 'updates_screen.dart';
import 'budget_screen.dart';
import 'warranty_screen.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int index)? onNavigate;
  const HomeScreen({super.key, this.onNavigate});

  void _goTo(BuildContext context, int index) {
    if (onNavigate != null) {
      onNavigate!(index);
    }
  }

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
        title: Row(
          children: [
            SizedBox(
              width: 28, height: 28,
              child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            Text(
              'BRICK BY BRICK',
              style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2.0),
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
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // PROJECT PROGRESS CARD — no hardcoded values
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('PROJECT PROGRESS', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8), letterSpacing: 2.0)),
                      const Icon(Icons.show_chart, color: Color(0xFFEA580C), size: 20),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '— %',
                    style: GoogleFonts.inter(fontSize: 56, fontWeight: FontWeight.w900, color: Colors.white, height: 1.0, letterSpacing: -2.0),
                  ),
                  const SizedBox(height: 8),
                  Text('NO ACTIVE PROJECT SET', style: GoogleFonts.merriweather(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF475569))),
                  const SizedBox(height: 24),
                  Stack(
                    children: [
                      Container(height: 4, width: double.infinity, color: const Color(0xFF334155)),
                      Container(height: 4, width: 0, color: const Color(0xFFEA580C)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('— DAYS ACTIVE', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF475569))),
                      Text('— DAYS REMAINING', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF475569))),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TODAY'S SNAPSHOT
            Row(
              children: [
                const Icon(Icons.today, size: 16, color: Color(0xFF0F172A)),
                const SizedBox(width: 8),
                Text("TODAY'S SNAPSHOT", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A), letterSpacing: 1.5)),
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
                _buildDataWidget(context, title: 'TODAY EXPENSE', icon: Icons.account_balance_wallet_outlined, navIndex: 3, highlight: true),
                _buildDataWidget(context, title: 'LABOUR ON SITE', icon: Icons.groups_outlined, screen: const HRScreen(), highlight: false),
                _buildDataWidget(context, title: 'MATERIAL RECVD', icon: Icons.inventory_2_outlined, navIndex: 2, highlight: false),
                _buildDataWidget(context, title: 'WORK STATUS', icon: Icons.engineering_outlined, navIndex: 1, highlight: false),
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
                _buildQuickAction(context, Icons.account_balance_wallet_outlined, 'Budget', navIndex: 3),
                const SizedBox(width: 12),
                _buildQuickAction(context, Icons.groups_outlined, 'Labour', screen: const HRScreen()),
                const SizedBox(width: 12),
                _buildQuickAction(context, Icons.inventory_2_outlined, 'Material', navIndex: 2),
                const SizedBox(width: 12),
                _buildQuickAction(context, Icons.article_outlined, 'Updates', navIndex: 1),
              ],
            ),

            const SizedBox(height: 28),

            // NAVIGATE SECTIONS
            Row(
              children: [
                const Icon(Icons.grid_view, size: 16, color: Color(0xFF0F172A)),
                const SizedBox(width: 8),
                Text('ALL SECTIONS', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A), letterSpacing: 1.5)),
              ],
            ),
            const SizedBox(height: 14),

            _buildNavItem(context, icon: Icons.account_balance_wallet_outlined, label: 'Budget & Bills', subtitle: 'Track daily expenses and invoices', color: const Color(0xFFEA580C), navIndex: 3),
            _buildNavItem(context, icon: Icons.groups_outlined, label: 'Labour Management', subtitle: 'Site headcount, wages and vendors', color: const Color(0xFF0EA5E9), screen: const HRScreen()),
            _buildNavItem(context, icon: Icons.inventory_2_outlined, label: 'Materials', subtitle: 'Cement, steel, sand and supplies', color: const Color(0xFF10B981), navIndex: 2),
            _buildNavItem(context, icon: Icons.article_outlined, label: 'Site Updates', subtitle: 'Daily progress notes and photos', color: const Color(0xFF8B5CF6), navIndex: 1),
            _buildNavItem(context, icon: Icons.verified_user_outlined, label: 'Warranty', subtitle: 'Material and work warranties', color: const Color(0xFFF59E0B), navIndex: 4),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDataWidget(BuildContext context, {
    required String title,
    required IconData icon,
    int? navIndex,
    Widget? screen,
    required bool highlight,
  }) {
    return GestureDetector(
      onTap: () {
        if (navIndex != null) _goTo(context, navIndex);
        if (screen != null) _openScreen(context, screen);
      },
      child: Container(
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
                Flexible(
                  child: Text(title, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: highlight ? const Color(0xFF0F172A) : const Color(0xFF64748B), letterSpacing: 1.0)),
                ),
                Icon(icon, size: 16, color: highlight ? const Color(0xFFEA580C) : const Color(0xFF94A3B8)),
              ],
            ),
            Text('—', style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w900, color: const Color(0xFF94A3B8), letterSpacing: -1.0, height: 1.2)),
            Row(
              children: [
                Text('Tap to view', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600, color: const Color(0xFF94A3B8))),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 10, color: Color(0xFF94A3B8)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, {int? navIndex, Widget? screen}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (navIndex != null) _goTo(context, navIndex);
          if (screen != null) _openScreen(context, screen);
        },
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
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    int? navIndex,
    Widget? screen,
  }) {
    return GestureDetector(
      onTap: () {
        if (navIndex != null) _goTo(context, navIndex);
        if (screen != null) _openScreen(context, screen);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: color.withOpacity(0.10), borderRadius: BorderRadius.circular(4)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
                  const SizedBox(height: 2),
                  Text(subtitle, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400, color: const Color(0xFF64748B))),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
          ],
        ),
      ),
    );
  }
}
