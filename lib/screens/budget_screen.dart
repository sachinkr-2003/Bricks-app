import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'form_screen.dart';
import 'invoice_screen.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  List<dynamic> _expenses = [];
  bool _isLoading = true;
  String _error = '';

  int get _totalAmount => _expenses.fold(0, (sum, e) => sum + ((e['amount'] ?? 0) as num).toInt());
  int get _paidAmount => _expenses.where((e) => e['status'] == 'Paid').fold(0, (sum, e) => sum + ((e['amount'] ?? 0) as num).toInt());
  int get _pendingAmount => _totalAmount - _paidAmount;

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _fetchExpenses() async {
    setState(() { _isLoading = true; _error = ''; });
    final res = await ApiService().getData('/expenses');
    if (!mounted) return;
    if (res['success']) {
      setState(() { _expenses = res['data']; _isLoading = false; });
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
        title: Text('Cost & Budget', style: GoogleFonts.merriweather(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long, color: Color(0xFFEA580C)),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InvoiceScreen())),
          ),
          IconButton(icon: const Icon(Icons.refresh, color: Color(0xFF0F172A)), onPressed: _fetchExpenses),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFEA580C)))
          : RefreshIndicator(
              onRefresh: _fetchExpenses,
              color: const Color(0xFFEA580C),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary cards
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0))),
                      child: Column(
                        children: [
                          _buildFinancialRow('Total Expenses', '₹$_totalAmount', Colors.white, const Color(0xFF0F172A)),
                          _buildFinancialRow('Paid', '₹$_paidAmount', const Color(0xFFF0FDF4), Colors.green),
                          _buildFinancialRow('Pending', '₹$_pendingAmount', const Color(0xFFFFF7ED), const Color(0xFFEA580C)),
                        ],
                      ),
                    ),

                    if (_error.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        color: const Color(0xFFFEF2F2),
                        child: Row(
                          children: [
                            const Icon(Icons.warning, color: Colors.red, size: 16),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_error, style: const TextStyle(color: Colors.red, fontSize: 12))),
                            TextButton(onPressed: _fetchExpenses, child: const Text('Retry')),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        const Icon(Icons.list_alt, size: 14, color: Color(0xFF0F172A)),
                        const SizedBox(width: 8),
                        Text('EXPENSE HISTORY', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A), letterSpacing: 1.5)),
                        const Spacer(),
                        Text('${_expenses.length} entries', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (_expenses.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: Column(children: [
                          const Icon(Icons.account_balance_wallet_outlined, size: 56, color: Color(0xFFCBD5E1)),
                          const SizedBox(height: 16),
                          Text('No Expenses Logged', style: GoogleFonts.merriweather(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF0F172A))),
                          const SizedBox(height: 8),
                          const Text('Hit "ADD EXPENSE" below to log your first expense.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                        ]),
                      )
                    else
                      ...(_expenses.map((e) => _buildExpenseCard(e)).toList()),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const FormScreen(title: 'Add New Expense')));
          if (result == true) _fetchExpenses();
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
      decoration: BoxDecoration(color: bgColor, border: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B))),
          Text(amount, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: textColor)),
        ],
      ),
    );
  }

  Widget _buildExpenseCard(Map<String, dynamic> e) {
    final isPaid = e['status'] == 'Paid';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: isPaid ? Colors.green : const Color(0xFFEA580C), width: 3), top: const BorderSide(color: Color(0xFFE2E8F0)), right: const BorderSide(color: Color(0xFFE2E8F0)), bottom: const BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(e['title'] ?? 'Expense', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, color: const Color(0xFF0F172A))),
                const SizedBox(height: 4),
                Text('To: ${e['paidTo'] ?? '—'}  •  ${(e['createdAt'] ?? '').toString().substring(0, 10)}', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('₹${e['amount'] ?? 0}', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 16, color: const Color(0xFF0F172A))),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(border: Border.all(color: isPaid ? Colors.green : const Color(0xFFEA580C)), color: isPaid ? Colors.green.withOpacity(0.1) : const Color(0xFFEA580C).withOpacity(0.1)),
                child: Text(isPaid ? 'PAID' : 'PENDING', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isPaid ? Colors.green : const Color(0xFFEA580C))),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
