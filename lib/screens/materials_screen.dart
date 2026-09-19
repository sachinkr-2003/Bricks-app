import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaterialsScreen extends StatelessWidget {
  const MaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
        title: Text(
          'Material & Bills',
          style: GoogleFonts.merriweather(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list, color: Color(0xFF0F172A)), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMaterialCard('Cement (Ultratech)', '100 Bags', 'Shree Building Materials', '₹35,000', '15 Sep 2026', true),
          const SizedBox(height: 12),
          _buildMaterialCard('Steel (TMT 12mm)', '800 Kg', 'IronWorks India', '₹45,500', '10 Sep 2026', false),
          const SizedBox(height: 12),
          _buildMaterialCard('Bricks (Red)', '5000 Pcs', 'Local Brick Kiln', '₹40,000', '02 Sep 2026', true),
        ],
      ),
    );
  }

  Widget _buildMaterialCard(String name, String qty, String supplier, String amount, String date, bool isPaid) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: GoogleFonts.merriweather(fontWeight: FontWeight.bold, fontSize: 15, color: const Color(0xFF0F172A))),
                      const SizedBox(height: 4),
                      Text('Qty: $qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B))),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.store, size: 12, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Text(supplier, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(amount, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF0F172A))),
                    const SizedBox(height: 4),
                    Text(date, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: isPaid ? Colors.green : const Color(0xFFEA580C)),
                        color: isPaid ? Colors.green.withOpacity(0.1) : const Color(0xFFEA580C).withOpacity(0.1),
                      ),
                      child: Text(
                        isPaid ? 'PAID' : 'PENDING',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isPaid ? Colors.green : const Color(0xFFEA580C)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(color: Color(0xFFF8FAFC), border: Border(top: BorderSide(color: Color(0xFFE2E8F0)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.receipt, size: 16, color: Color(0xFF0F172A)),
                const SizedBox(width: 8),
                const Text('VIEW BILL INVOICE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF0F172A), letterSpacing: 0.5)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
