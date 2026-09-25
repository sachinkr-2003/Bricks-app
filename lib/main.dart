import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/materials_screen.dart';
import 'screens/updates_screen.dart';
import 'screens/budget_screen.dart';
import 'screens/warranty_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const BrickByBrickApp());
}

class BrickByBrickApp extends StatelessWidget {
  const BrickByBrickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brick By Brick',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Classic, strict color palette
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEA580C), // Orange
          primary: const Color(0xFF0F172A), // Slate 900
          secondary: const Color(0xFFEA580C),
          background: const Color(0xFFF8FAFC), // Slate 50
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        // Professional Serif/Sans-serif hybrid look
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).copyWith(
          displayLarge: GoogleFonts.merriweather(),
          displayMedium: GoogleFonts.merriweather(),
          displaySmall: GoogleFonts.merriweather(),
          headlineLarge: GoogleFonts.merriweather(),
          headlineMedium: GoogleFonts.merriweather(),
          headlineSmall: GoogleFonts.merriweather(),
        ),
        // SQUARE DESIGN: No rounded corners anywhere
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.zero),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Color(0xFFCBD5E1))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Color(0xFF0F172A), width: 2)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onNavigate: (index) => setState(() => _currentIndex = index)),
      const UpdatesScreen(),
      const MaterialsScreen(),
      const BudgetScreen(),
      const WarrantyScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFEA580C),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.article_outlined), activeIcon: Icon(Icons.article), label: 'Updates'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), activeIcon: Icon(Icons.inventory_2), label: 'Materials'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), activeIcon: Icon(Icons.account_balance_wallet), label: 'Budget'),
            BottomNavigationBarItem(icon: Icon(Icons.verified_user_outlined), activeIcon: Icon(Icons.verified_user), label: 'Warranty'),
          ],
        ),
      ),
    );
  }
}
