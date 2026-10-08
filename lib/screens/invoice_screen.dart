import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  bool _showPreview = false;

  Future<void> _generatePdf() async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('BRICK BY BRICK', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Premium Construction Management', style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: PdfColors.orange700,
                      child: pw.Text('INVOICE', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
                pw.SizedBox(height: 24),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 12),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('BILLED TO:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                        pw.Text(_clientController.text, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                        if (_projectController.text.isNotEmpty)
                          pw.Text('Site: ${_projectController.text}', style: const pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Date: ${DateTime.now().toString().substring(0, 10)}', style: const pw.TextStyle(fontSize: 11)),
                        pw.Text('Invoice #: BBB-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}', style: const pw.TextStyle(fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 24),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  children: [
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Amount (INR)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(_descriptionController.text.isNotEmpty ? _descriptionController.text : 'Contractual Construction Work')),
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Rs. ${_amountController.text}', textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 24),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text('Total Payable: Rs. ${_amountController.text}', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.orange800)),
                  ],
                ),
                pw.SizedBox(height: 48),
                pw.Text('Thank you for choosing Brick By Brick!', style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
              ],
            ),
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save(), name: 'Invoice-${_clientController.text}.pdf');
  }

  @override
  Widget build(BuildContext context) {
    if (_showPreview) return _buildPreview();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Generate Invoice', style: GoogleFonts.merriweather(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
        shape: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('INVOICE DETAILS', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFFEA580C), letterSpacing: 1.5)),
            const SizedBox(height: 16),
            
            _buildField('Client Name', 'e.g. Rahul Sharma', _clientController),
            const SizedBox(height: 16),
            _buildField('Project/Site Name', 'e.g. Rose Villa - Block A', _projectController),
            const SizedBox(height: 16),
            _buildField('Total Amount (₹)', 'e.g. 50000', _amountController, isNumber: true),
            const SizedBox(height: 16),
            _buildField('Description of Work', 'e.g. 1st Floor Slab Casting Phase 1', _descriptionController, isLarge: true),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (_clientController.text.isEmpty || _amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all details')));
                    return;
                  }
                  setState(() => _showPreview = true);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                child: Text('PREVIEW INVOICE', style: GoogleFonts.inter(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, TextEditingController controller, {bool isLarge = false, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: isLarge ? 3 : 1,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
            enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Color(0xFF0F172A), width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Invoice Preview', style: GoogleFonts.merriweather(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)), onPressed: () => setState(() => _showPreview = false)),
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Color(0xFFEA580C)),
            tooltip: 'Print or Save PDF',
            onPressed: _generatePdf,
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Color(0xFFEA580C)),
            tooltip: 'Share PDF',
            onPressed: _generatePdf,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('BRICK BY BRICK', style: GoogleFonts.merriweather(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                      const SizedBox(height: 4),
                      const Text('Construction Management', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    color: const Color(0xFFEA580C),
                    child: Text('INVOICE', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                  )
                ],
              ),
              const SizedBox(height: 32),
              const Divider(color: Color(0xFFE2E8F0), thickness: 1),
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Billed To:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                      const SizedBox(height: 4),
                      Text(_clientController.text, style: GoogleFonts.merriweather(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                      const SizedBox(height: 2),
                      Text(_projectController.text, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Date:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                      const SizedBox(height: 4),
                      Text(DateTime.now().toString().split(' ')[0], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              const Text('Description', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: const Color(0xFFF8FAFC),
                child: Text(_descriptionController.text, style: const TextStyle(height: 1.5, fontSize: 13, color: Color(0xFF334155))),
              ),
              
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Amount Due:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  Text('₹${_amountController.text}', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A))),
                ],
              ),
              
              const SizedBox(height: 48),
              const Center(
                child: Text('Thank you for your business.', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF94A3B8))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
