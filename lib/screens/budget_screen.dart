import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
        title: Text(
          'Cost & Budget',
          style: GoogleFonts.merriweather(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Column(
                children: [
                  _buildFinancialRow('Total Contract Value', '₹50,00,000', Colors.white, const Color(0xFF0F172A)),
                  _buildFinancialRow('Amount Paid', '₹32,00,000', const Color(0xFFF0FDF4), Colors.green),
                  _buildFinancialRow('Amount Remaining', '₹18,00,000', const Color(0xFFFFF7ED), const Color(0xFFEA580C)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ADDITIONAL EXPENSES',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                      Container(color: const Color(0xFF334155), padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), child: const Text('STRICT', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Requires Customer Approval', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                  const SizedBox(height: 16),
                  
                  const Text('Pending Request:', style: TextStyle(color: Color(0xFFFBA11B), fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Borewell Motor Change', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      const Text('₹25,000', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEA580C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('APPROVE EXPENSE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('PAYMENT MILESTONES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 1)),
            ),
            const SizedBox(height: 12),
            _buildMilestone('Plinth Level (20%)', '₹10,00,000', true),
            _buildMilestone('Roof Slab (25%)', '₹12,50,000', true),
            _buildMilestone('Brickwork (20%)', '₹10,00,000', false),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialRow(String title, String amount, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        border: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B))),
          Text(amount, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: textColor)),
        ],
      ),
    );
  }

  Widget _buildMilestone(String name, String amount, bool isPaid) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: isPaid ? Colors.green : const Color(0xFFE2E8F0)),
          right: BorderSide(color: isPaid ? Colors.green : const Color(0xFFE2E8F0)),
          bottom: BorderSide(color: isPaid ? Colors.green : const Color(0xFFE2E8F0)),
          left: BorderSide(color: isPaid ? Colors.green : const Color(0xFFE2E8F0), width: 4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(isPaid ? Icons.check_circle : Icons.schedule, size: 12, color: isPaid ? Colors.green : const Color(0xFF94A3B8)),
                  const SizedBox(width: 4),
                  Text(isPaid ? 'Received' : 'Pending', style: TextStyle(fontSize: 11, color: isPaid ? Colors.green : const Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
