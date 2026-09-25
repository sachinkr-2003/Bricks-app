import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'hr_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int index)? onNavigate;
  const HomeScreen({super.key, this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  String _userName = 'User';
  String _userRole = '';

  // Live dashboard data
  int _todayExpense = 0;
  int _totalBills = 0;
  int _labourOnSite = 0;
  int _materialsCount = 0;
  String _workStatus = '—';
  int _totalUpdates = 0;

  @override
  void initState() {
    super.initState();
    _loadUserAndData();
  }

  Future<void> _loadUserAndData() async {
    setState(() => _isLoading = true);

    // Load user from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user');
    if (userStr != null) {
      try {
        final userData = jsonDecode(userStr);
        _userName = userData['name'] ?? 'User';
        _userRole = (userData['role'] ?? '').toString().toUpperCase();
      } catch (_) {}
    }

    // Fetch all data in parallel
    final results = await Future.wait([
      ApiService().getData('/expenses'),
      ApiService().getData('/analytics/dashboard'),
      ApiService().getData('/materials'),
      ApiService().getData('/updates'),
    ]);

    if (!mounted) return;

    // Parse expenses → today's total
    if (results[0]['success'] == true) {
      final expenses = results[0]['data'] as List;
      final today = DateTime.now();
      int todayTotal = 0;
      for (final e in expenses) {
        final dateStr = (e['createdAt'] ?? '').toString();
        if (dateStr.length >= 10) {
          final d = DateTime.tryParse(dateStr.substring(0, 10));
          if (d != null && d.year == today.year && d.month == today.month && d.day == today.day) {
            todayTotal += ((e['amount'] ?? 0) as num).toInt();
          }
        }
      }
      _todayExpense = todayTotal;
      _totalBills = expenses.length;
    }

    // Parse analytics dashboard
    if (results[1]['success'] == true) {
      final data = results[1]['data'];
      _labourOnSite = ((data['totalActiveWorkers'] ?? 0) as num).toInt();
    }

    // Parse materials
    if (results[2]['success'] == true) {
      _materialsCount = (results[2]['data'] as List).length;
    }

    // Parse updates → latest work status
    if (results[3]['success'] == true) {
      final updates = results[3]['data'] as List;
      _totalUpdates = updates.length;
      if (updates.isNotEmpty) {
        _workStatus = updates.first['workCompleted'] ?? updates.first['workInProgress'] ?? '—';
        if (_workStatus.length > 16) _workStatus = '${_workStatus.substring(0, 14)}…';
      }
    }

    setState(() => _isLoading = false);
  }

  void _goTo(int index) {
    widget.onNavigate?.call(index);
  }

  void _openScreen(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  String _formatAmount(int amount) {
    if (amount >= 100000) return '₹${(amount / 100000).toStringAsFixed(1)}L';
    if (amount >= 1000) return '₹${(amount / 1000).toStringAsFixed(1)}k';
    return '₹$amount';
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
            SizedBox(width: 28, height: 28, child: Image.asset('assets/images/logo.png', fit: BoxFit.contain)),
            const SizedBox(width: 12),
            Text('BRICK BY BRICK', style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2.0)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Badge(backgroundColor: Color(0xFFEA580C), smallSize: 8, child: Icon(Icons.notifications_none, color: Color(0xFF0F172A))),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.refresh_outlined, color: Color(0xFF0F172A), size: 20), onPressed: _loadUserAndData),
          const SizedBox(width: 4),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFEA580C), strokeWidth: 2))
          : RefreshIndicator(
              onRefresh: _loadUserAndData,
              color: const Color(0xFFEA580C),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Welcome Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        border: Border.all(color: const Color(0xFF1E293B)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Good day, $_userName', style: GoogleFonts.merriweather(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                                const SizedBox(height: 4),
                                Text(_userRole.isEmpty ? 'Welcome back' : _userRole, style: GoogleFonts.inter(color: const Color(0xFFEA580C), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(border: Border.all(color: const Color(0xFF334155))),
                            child: Text('TODAY', style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // TODAY'S SNAPSHOT
                    Row(
                      children: [
                        const Icon(Icons.today, size: 14, color: Color(0xFF0F172A)),
                        const SizedBox(width: 8),
                        Text("TODAY'S SNAPSHOT", style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A), letterSpacing: 1.5)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.05,
                      children: [
                        _buildDataCard(
                          title: 'TODAY EXPENSE',
                          value: _todayExpense > 0 ? _formatAmount(_todayExpense) : '₹0',
                          subtitle: '$_totalBills bills total',
                          icon: Icons.account_balance_wallet_outlined,
                          highlight: true,
                          onTap: () => _goTo(3),
                        ),
                        _buildDataCard(
                          title: 'LABOUR ON SITE',
                          value: _labourOnSite.toString().padLeft(2, '0'),
                          subtitle: 'Workers logged',
                          icon: Icons.groups_outlined,
                          highlight: false,
                          onTap: () => _openScreen(const HRScreen()),
                        ),
                        _buildDataCard(
                          title: 'MATERIAL BILLS',
                          value: _materialsCount.toString(),
                          subtitle: 'Entries logged',
                          icon: Icons.inventory_2_outlined,
                          highlight: false,
                          onTap: () => _goTo(2),
                        ),
                        _buildDataCard(
                          title: 'WORK STATUS',
                          value: _totalUpdates > 0 ? 'Active' : 'None',
                          subtitle: _workStatus,
                          icon: Icons.engineering_outlined,
                          highlight: false,
                          onTap: () => _goTo(1),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // QUICK ACTIONS
                    Row(
                      children: [
                        const Icon(Icons.bolt, size: 14, color: Color(0xFF0F172A)),
                        const SizedBox(width: 8),
                        Text('QUICK ACTIONS', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A), letterSpacing: 1.5)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildQuickAction(Icons.account_balance_wallet_outlined, 'Budget', () => _goTo(3)),
                        const SizedBox(width: 10),
                        _buildQuickAction(Icons.groups_outlined, 'Labour', () => _openScreen(const HRScreen())),
                        const SizedBox(width: 10),
                        _buildQuickAction(Icons.inventory_2_outlined, 'Material', () => _goTo(2)),
                        const SizedBox(width: 10),
                        _buildQuickAction(Icons.article_outlined, 'Updates', () => _goTo(1)),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ALL SECTIONS
                    Row(
                      children: [
                        const Icon(Icons.grid_view, size: 14, color: Color(0xFF0F172A)),
                        const SizedBox(width: 8),
                        Text('ALL SECTIONS', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A), letterSpacing: 1.5)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildNavItem(icon: Icons.account_balance_wallet_outlined, label: 'Budget & Bills', subtitle: 'Track daily expenses and invoices', color: const Color(0xFFEA580C), onTap: () => _goTo(3)),
                    _buildNavItem(icon: Icons.groups_outlined, label: 'Labour Management', subtitle: 'Site headcount, wages and vendors', color: const Color(0xFF0EA5E9), onTap: () => _openScreen(const HRScreen())),
                    _buildNavItem(icon: Icons.inventory_2_outlined, label: 'Materials', subtitle: 'Cement, steel, sand and supplies', color: const Color(0xFF10B981), onTap: () => _goTo(2)),
                    _buildNavItem(icon: Icons.article_outlined, label: 'Site Updates', subtitle: 'Daily progress notes and photos', color: const Color(0xFF8B5CF6), onTap: () => _goTo(1)),
                    _buildNavItem(icon: Icons.verified_user_outlined, label: 'Warranty', subtitle: 'Material and work warranties', color: const Color(0xFFF59E0B), onTap: () => _goTo(4)),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDataCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required bool highlight,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: highlight ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0), width: highlight ? 2.0 : 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(title, style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: highlight ? const Color(0xFF0F172A) : const Color(0xFF64748B), letterSpacing: 0.8))),
                Icon(icon, size: 15, color: highlight ? const Color(0xFFEA580C) : const Color(0xFF94A3B8)),
              ],
            ),
            Text(value, style: GoogleFonts.inter(fontSize: 30, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A), letterSpacing: -1.0, height: 1.1)),
            Row(
              children: [
                Flexible(child: Text(subtitle, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w500, color: const Color(0xFF64748B)), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE2E8F0))),
          child: Column(children: [
            Icon(icon, color: const Color(0xFF0F172A), size: 20),
            const SizedBox(height: 5),
            Text(label, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 0.5), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required String subtitle, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE2E8F0))),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.10), borderRadius: BorderRadius.circular(4)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
              const SizedBox(height: 2),
              Text(subtitle, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400, color: const Color(0xFF64748B))),
            ]),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 18),
        ]),
      ),
    );
  }
}
