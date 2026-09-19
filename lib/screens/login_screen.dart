import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() {
    setState(() => _isLoading = true);
    
    // Simulate API delay
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B14), // Ultra deep slate/black
      body: Stack(
        children: [
          // Background Aesthetic Grid Overlay
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(),
            ),
          ),
          
          // Orange Glow Effect (Top Right)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEA580C).withOpacity(0.15),
                backgroundBlendMode: BlendMode.screen,
              ),
              child: BackdropFilter(
                filter: ColorFilter.mode(Colors.transparent, BlendMode.srcOver),
                child: Container(color: Colors.transparent), // Forces blur calculation
              ),
            ),
          ),
          
          // Blue Glow Effect (Bottom Left)
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2563EB).withOpacity(0.10),
                backgroundBlendMode: BlendMode.screen,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    // Brand Identity
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BRICK BY',
                              style: GoogleFonts.merriweather(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                letterSpacing: 2.0,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              'BRICK',
                              style: GoogleFonts.merriweather(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                letterSpacing: 2.0,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    Text(
                      'CLIENT PORTAL AUTHENTICATION',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Login Box
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A).withOpacity(0.8), // Dark slate glass
                        border: Border.all(color: const Color(0xFF1E293B)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Authorization',
                            style: GoogleFonts.merriweather(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Enter your connected mobile number to continue.',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Custom Dark Field: Phone
                          _buildPremiumTextField(
                            label: 'REGISTERED MOBILE',
                            controller: _phoneController,
                            icon: Icons.phone_android,
                            hint: '98765 43210',
                            isObscure: false,
                          ),
                          const SizedBox(height: 24),
                          
                          // Custom Dark Field: Password
                          _buildPremiumTextField(
                            label: 'SECURE PIN',
                            controller: _passwordController,
                            icon: Icons.lock_outline,
                            hint: '••••••••',
                            isObscure: true,
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEA580C),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              ),
                              child: _isLoading 
                                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : Text('ACCESS DASHBOARD', style: GoogleFonts.inter(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    Center(
                      child: Text(
                        'POWERED BY BRICK BY BRICK ENTERPRISE SECURE',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF475569),
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required bool isObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF94A3B8),
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF070B14),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                color: const Color(0xFF1E293B).withOpacity(0.5),
                child: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: isObscure,
                  keyboardType: isObscure ? TextInputType.text : TextInputType.phone,
                  style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.inter(color: const Color(0xFF475569), fontWeight: FontWeight.w500),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// Custom Grid Painter for the architectural background
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E293B).withOpacity(0.3)
      ..strokeWidth = 1;

    const double spacing = 32.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
