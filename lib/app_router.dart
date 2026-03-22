import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testpro26/main.dart';
import 'package:testpro26/pages/home_page.dart';
import 'package:testpro26/pages/barcode_scanner_page.dart';
import 'package:testpro26/pages/product_details_page.dart';
import 'package:testpro26/pages/compare_page.dart';

// Simple Dashboard Wrapper
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const SafeArea(
        child: HomePage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.compare_arrows), label: 'Compare'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 2) context.push('/compare');
        },
      ),
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/scanner',
      builder: (context, state) => const BarcodeScannerPage(standalone: true),
    ),
    // Map /product to ProductScreen, utilizing parameter matching
    GoRoute(
      path: '/product/:barcode',
      builder: (context, state) {
        final barcode = state.pathParameters['barcode'] ?? '';
        return ProductDetailsPage(barcode: barcode);
      },
    ),
    GoRoute(
      path: '/compare',
      builder: (context, state) => const ComparePage(),
    ),
  ],
);
