import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'form_screen.dart';

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  List<dynamic> _materials = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMaterials();
  }

  Future<void> _fetchMaterials() async {
    final res = await ApiService().getData('/materials');
    if (res['success'] && mounted) {
      setState(() {
        _materials = res['data'];
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

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
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _materials.isEmpty 
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 64, color: const Color(0xFFCBD5E1)),
                        const SizedBox(height: 16),
                        Text('No Materials Logged', style: GoogleFonts.merriweather(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF0F172A))),
                        const SizedBox(height: 8),
                        Text('Hit the "ADD MATERIAL" button below to start tracking your purchases and bills.', textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFF64748B), fontSize: 13)),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _materials.length,
                  itemBuilder: (context, index) {
                    final item = _materials[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildMaterialCard(
                        item['materialName'] ?? 'Unknown',
                        '${item['quantity']} ${item['unit']}',
                        item['supplierName'] ?? 'Unknown',
                        '₹${item['totalCost']}',
                        'Date: ${item['date']}'.substring(0, 16),
                        item['status'] == 'Paid'
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormScreen(title: 'Add New Material')),
          );
          if (result == true) {
            _fetchMaterials();
          }
        },
        backgroundColor: const Color(0xFFEA580C),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('ADD MATERIAL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
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
