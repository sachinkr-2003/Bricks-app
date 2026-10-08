import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class FormScreen extends StatefulWidget {
  // Title determines what form fields are shown:
  // 'Add New Material', 'Add New Expense', 'Submit Daily Update', 'Lodge Complaint'
  final String title;

  const FormScreen({super.key, required this.title});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSaving = false;

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images.map((img) => File(img.path)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting images: $e')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    // Only require image for material bills
    if (_selectedImages.isEmpty && widget.title == 'Add New Material') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please attach the bill photo for material entry!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // 1. Upload Images ONLY IF user selected any
      List<dynamic> urls = [];
      String mainImageUrl = '';
      if (_selectedImages.isNotEmpty) {
        List<String> filePaths = _selectedImages.map((f) => f.path).toList();
        final uploadResult = await ApiService().uploadImages(filePaths);
        if (uploadResult['success'] == true) {
          urls = uploadResult['urls'] ?? [];
          if (urls.isNotEmpty) mainImageUrl = urls[0];
        } else {
          throw Exception(uploadResult['message'] ?? 'Image upload failed');
        }
      }

      // 2. Determine Endpoint and Payload based on Form Title
      String endpoint = '';
      Map<String, dynamic> payload = {};

      if (widget.title == 'Add New Material') {
        endpoint = '/materials';
        payload = {
          'materialName': _getController('Material Name').text,
          'quantity': num.tryParse(_getController('Quantity').text) ?? 0,
          'unit': _getController('Unit').text.isNotEmpty ? _getController('Unit').text : 'Bags',
          'totalCost': num.tryParse(_getController('Total Amount (₹)').text) ?? 0,
          'supplierName': _getController('Supplier Name').text,
          'status': 'Pending',
          'billImage': mainImageUrl,
        };
      } else if (widget.title == 'Add New Expense') {
        endpoint = '/expenses';
        payload = {
          'title': _getController('Expense Title').text,
          'amount': num.tryParse(_getController('Amount (₹)').text) ?? 0,
          'paidTo': _getController('Paid To').text,
          'remarks': _getController('Expense Remarks').text.isNotEmpty ? _getController('Expense Remarks').text : 'None',
          'status': 'Pending',
          'billImage': mainImageUrl,
        };
      } else if (widget.title == 'Submit Daily Update') {
        endpoint = '/updates';
        payload = {
          'workCompleted': _getController('Work Completed Today').text,
          'workInProgress': _getController('Work In Progress').text.isNotEmpty ? _getController('Work In Progress').text : 'None',
          'nextPlan': _getController('Next Plan (Tomorrow)').text.isNotEmpty ? _getController('Next Plan (Tomorrow)').text : 'None',
          'issues': _getController('Any Issues/Delays?').text.isNotEmpty ? _getController('Any Issues/Delays?').text : 'None',
          'photos': urls.isNotEmpty ? urls : [], // save all photos
        };
      } else if (widget.title == 'Lodge Complaint') {
        endpoint = '/warranties';
        payload = {
          'issueType': _getController('Issue Title').text.isNotEmpty ? _getController('Issue Title').text : 'Other',
          'description': _getController('Detailed Description').text.isNotEmpty ? _getController('Detailed Description').text : 'Complaint submitted via app',
        };
      }

      // 3. Post Final Payload if endpoint exists
      if (endpoint.isNotEmpty) {
        final submitResult = await ApiService().postData(endpoint, payload);
        if (!submitResult['success']) throw Exception(submitResult['message']);
      }

      if (!mounted) return;
      setState(() => _isSaving = false);
      Navigator.pop(context, true); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data Saved Live Successfully!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.merriweather(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
        shape: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // DYNAMIC FORM FIELDS BASED ON TITLE
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DATA ENTRY FIELDS',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFFEA580C), letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 16),
                  
                  if (widget.title == 'Add New Material') ...[
                    _buildField('Material Name', 'e.g. Ultratech Cement', Icons.inventory_2),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildField('Quantity', 'e.g. 100', Icons.numbers)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildField('Unit', 'e.g. Bags / Kg', Icons.scale)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildField('Total Amount (₹)', 'e.g. 35,000', Icons.currency_rupee),
                    const SizedBox(height: 16),
                    _buildField('Supplier Name', 'e.g. Shree Building Materials', Icons.store),
                  ] 
                  
                  else if (widget.title == 'Add New Expense') ...[
                    _buildField('Expense Title', 'e.g. Borewell Motor Repair', Icons.build),
                    const SizedBox(height: 16),
                    _buildField('Amount (₹)', 'e.g. 25,000', Icons.currency_rupee),
                    const SizedBox(height: 16),
                    _buildField('Paid To', 'e.g. Raju Plumber', Icons.person),
                    const SizedBox(height: 16),
                    _buildField('Expense Remarks', 'Reason for expense...', Icons.notes, isLarge: true),
                  ] 
                  
                  else if (widget.title == 'Submit Daily Update') ...[
                    _buildField('Work Completed Today', 'e.g. Slab Shuttering Finished', Icons.check_circle),
                    const SizedBox(height: 16),
                    _buildField('Work In Progress', 'e.g. Steel Binding', Icons.loop),
                    const SizedBox(height: 16),
                    _buildField('Next Plan (Tomorrow)', 'e.g. Concrete Pouring', Icons.trending_flat),
                    const SizedBox(height: 16),
                    _buildField('Any Issues/Delays?', 'e.g. Need more aggregate material', Icons.warning, isLarge: true),
                  ] 
                  
                  else ...[
                    // Default fallback or Complaint
                    _buildField('Issue Title', 'e.g. Water Leakage in Basement', Icons.title),
                    const SizedBox(height: 16),
                    _buildField('Detailed Description', 'Explain the problem in detail...', Icons.description, isLarge: true),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 8),

            // MULTIPLE IMAGE UPLOAD SECTION
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ATTACH PROOF / PHOTOS',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFFEA580C), letterSpacing: 1.5),
                      ),
                      Text('${_selectedImages.length} attached', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B), fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _selectedImages.isEmpty 
                    ? InkWell(
                        onTap: _pickImages,
                        child: Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid, width: 2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_photo_alternate, size: 32, color: Color(0xFF94A3B8)),
                              const SizedBox(height: 8),
                              Text('Tap to select multiple photos', style: GoogleFonts.inter(color: const Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              ..._selectedImages.asMap().entries.map((entry) {
                                int idx = entry.key;
                                File imgFile = entry.value;
                                return Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: const Color(0xFFE2E8F0)),
                                        image: DecorationImage(image: FileImage(imgFile), fit: BoxFit.cover),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () => _removeImage(idx),
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                          child: const Icon(Icons.close, color: Colors.white, size: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                              
                              // "Add More" Button
                              GestureDetector(
                                onTap: _pickImages,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    border: Border.all(color: const Color(0xFFCBD5E1)),
                                  ),
                                  child: const Icon(Icons.add, color: Color(0xFF64748B), size: 32),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // SUBMIT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: SizedBox(
                  width: 250,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                    child: _isSaving 
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text('SAVE RECORD', style: GoogleFonts.inter(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  final Map<String, TextEditingController> _controllers = {};

  TextEditingController _getController(String label) {
    return _controllers.putIfAbsent(label, () => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildField(String label, String hint, IconData icon, {bool isLarge = false}) {
    final controller = _getController(label);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: isLarge ? 3 : 1,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: isLarge ? null : Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Color(0xFF0F172A), width: 2)),
          ),
        ),
      ],
    );
  }
}
