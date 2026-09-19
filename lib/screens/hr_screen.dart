import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HRScreen extends StatefulWidget {
  const HRScreen({super.key});

  @override
  State<HRScreen> createState() => _HRScreenState();
}

class _HRScreenState extends State<HRScreen> {
  int _selectedTab = 0; // 0 for Labours, 1 for Vendors

  final List<Map<String, String>> _labours = [
    {'id': 'L-101', 'name': 'Raju', 'category': 'Mistri', 'wage': '₹800'},
    {'id': 'L-103', 'name': 'Suresh', 'category': 'Helper', 'wage': '₹500'},
  ];

  final List<Map<String, String>> _vendors = [
    {'id': 'V-201', 'name': 'Shree Materials', 'category': 'Cement', 'contact': '9876543210'},
  ];

  void _showAddModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // to handle keyboard
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF0F172A), width: 1.5),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedTab == 0 ? 'REGISTER NEW LABOUR' : 'REGISTER VENDOR',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Form Fields
                _buildTextField('Full Name / Shop Name'),
                const SizedBox(height: 12),
                _buildTextField('Category / Material Type'),
                const SizedBox(height: 12),
                _buildTextField(_selectedTab == 0 ? 'Default Wage (₹)' : 'Contact Number'),
                
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // just dismiss for now, backend will handle save
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${_selectedTab == 0 ? "Labour" : "Vendor"} Added Successfully!'), backgroundColor: Colors.green),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                    child: Text('SAVE RECORD', style: GoogleFonts.inter(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF64748B)),
        ),
        const SizedBox(height: 4),
        TextField(
          decoration: const InputDecoration(
            isDense: true,
          ),
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
        title: Text(
          'Human & Resources',
          style: GoogleFonts.inter(
            color: const Color(0xFF0F172A),
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 2.0,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      body: Column(
        children: [
          // Custom Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTab == 0 ? const Color(0xFF0F172A) : Colors.white,
                        border: Border.all(color: const Color(0xFF0F172A)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'SITE LABOURS',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: _selectedTab == 0 ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 10,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTab == 1 ? const Color(0xFF0F172A) : Colors.white,
                        border: Border.all(color: const Color(0xFF0F172A)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'MATERIAL VENDORS',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: _selectedTab == 1 ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 10,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _selectedTab == 0 ? _labours.length : _vendors.length,
              itemBuilder: (context, index) {
                final item = _selectedTab == 0 ? _labours[index] : _vendors[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: const Color(0xFFE2E8F0), width: 1.5),
                      right: BorderSide(color: const Color(0xFFE2E8F0), width: 1.5),
                      bottom: BorderSide(color: const Color(0xFFE2E8F0), width: 1.5),
                      left: BorderSide(color: const Color(0xFFEA580C), width: 4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['name']!, style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 16)),
                          const SizedBox(height: 2),
                          Text('${item['id']} • ${item['category']}', style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text(
                        _selectedTab == 0 ? item['wage']! : item['contact']!,
                        style: GoogleFonts.merriweather(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A), fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddModal,
        backgroundColor: const Color(0xFFEA580C),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
