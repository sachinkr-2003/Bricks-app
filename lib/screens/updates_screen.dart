import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'form_screen.dart';

class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({super.key});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  List<dynamic> _updates = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchUpdates();
  }

  Future<void> _fetchUpdates() async {
    setState(() { _isLoading = true; _error = ''; });
    final res = await ApiService().getData('/updates');
    if (!mounted) return;
    if (res['success']) {
      setState(() { _updates = res['data']; _isLoading = false; });
    } else {
      setState(() { _error = res['message'] ?? 'Failed to load'; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
        title: Text('Daily Updates', style: GoogleFonts.merriweather(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Color(0xFF0F172A)), onPressed: _fetchUpdates),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFEA580C)))
          : RefreshIndicator(
              onRefresh: _fetchUpdates,
              color: const Color(0xFFEA580C),
              child: _error.isNotEmpty
                  ? ListView(children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          color: const Color(0xFFFEF2F2),
                          child: Row(children: [
                            const Icon(Icons.warning, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_error, style: const TextStyle(color: Colors.red))),
                            TextButton(onPressed: _fetchUpdates, child: const Text('Retry')),
                          ]),
                        ),
                      )
                    ])
                  : _updates.isEmpty
                      ? ListView(children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE2E8F0))),
                              child: Column(children: [
                                const Icon(Icons.feed_outlined, size: 56, color: Color(0xFFCBD5E1)),
                                const SizedBox(height: 16),
                                Text('No Updates Yet', style: GoogleFonts.merriweather(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF0F172A))),
                                const SizedBox(height: 8),
                                const Text('Tap "NEW UPDATE" below to add today\'s progress.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                              ]),
                            ),
                          )
                        ])
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                          itemCount: _updates.length,
                          itemBuilder: (context, index) => _buildUpdateCard(_updates[index]),
                        ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const FormScreen(title: 'Submit Daily Update')));
          if (result == true) _fetchUpdates();
        },
        backgroundColor: const Color(0xFFEA580C),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('NEW UPDATE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
    );
  }

  Widget _buildUpdateCard(Map<String, dynamic> u) {
    final date = (u['createdAt'] ?? '').toString();
    final dateStr = date.length >= 10 ? date.substring(0, 10) : 'Unknown date';
    final photos = (u['photos'] as List?) ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFFF8FAFC),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dateStr, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF0F172A))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: const Color(0xFF0F172A),
                  child: const Text('DAILY', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildField('WORK COMPLETED', u['workCompleted'] ?? '—', Icons.check_circle_outline, Colors.green),
                const SizedBox(height: 10),
                _buildField('IN PROGRESS', u['workInProgress'] ?? '—', Icons.loop, Colors.blue),
                const SizedBox(height: 10),
                _buildField('NEXT PLAN', u['nextPlan'] ?? '—', Icons.trending_flat, const Color(0xFF94A3B8)),
                const SizedBox(height: 10),
                _buildField('ISSUES', u['issues'] ?? 'None', Icons.warning_amber_outlined,
                  (u['issues'] ?? 'None') != 'None' ? Colors.red : const Color(0xFF94A3B8)),
              ],
            ),
          ),
          if (photos.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE2E8F0)))),
              child: Row(children: [
                const Icon(Icons.photo_library, size: 16, color: Color(0xFFEA580C)),
                const SizedBox(width: 8),
                Text('${photos.length} photos attached', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              ]),
            ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String value, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 0.5)),
            const SizedBox(height: 2),
            Text(value, style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF334155), fontWeight: FontWeight.w500)),
          ]),
        ),
      ],
    );
  }
}
