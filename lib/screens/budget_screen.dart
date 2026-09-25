import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'form_screen.dart';
import 'invoice_screen.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long, color: Color(0xFFEA580C)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InvoiceScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Column(
                children: [
                  _buildFinancialRow('Total Contract Value', '₹0', Colors.white, const Color(0xFF0F172A)),
                  _buildFinancialRow('Amount Paid', '₹0', const Color(0xFFF0FDF4), Colors.green),
                  _buildFinancialRow('Amount Remaining', '₹0', const Color(0xFFFFF7ED), const Color(0xFFEA580C)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet_outlined, size: 64, color: const Color(0xFFCBD5E1)),
                  const SizedBox(height: 16),
                  Text('No Budget Data', style: GoogleFonts.merriweather(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF0F172A))),
                  const SizedBox(height: 8),
                  Text('Hit the "ADD EXPENSE" button below to log your first extra expense.', textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFF64748B), fontSize: 13)),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormScreen(title: 'Add New Expense')),
          );
        },
        backgroundColor: const Color(0xFFEA580C),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('ADD EXPENSE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
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
