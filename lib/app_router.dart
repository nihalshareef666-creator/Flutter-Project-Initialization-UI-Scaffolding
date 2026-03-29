import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testpro26/main.dart';
import 'package:testpro26/pages/home_page.dart';
import 'package:testpro26/pages/barcode_scanner_page.dart';
import 'package:testpro26/pages/product_details_page.dart';
import 'package:testpro26/pages/compare_page.dart';
import 'package:testpro26/pages/profile_page.dart';
import 'package:testpro26/pages/category_page.dart';
import 'package:testpro26/pages/auth/login_page.dart';
import 'package:testpro26/pages/search_page.dart';
import 'package:testpro26/pages/my_added_products_page.dart';
import 'package:testpro26/pages/edit_profile_page.dart';
import 'package:testpro26/pages/change_password_page.dart';
import 'package:testpro26/pages/ai_recommendations_page.dart';
import 'package:testpro26/pages/product_list_page.dart';

// Simple Dashboard Wrapper
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(), // Maps to bottom nav Search tab
    const ComparePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Compare',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 2) {
            context.push('/compare');
          } else {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
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
    GoRoute(path: '/compare', builder: (context, state) => const ComparePage()),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordPage(),
    ),
    GoRoute(
      path: '/ai-assistant',
      builder: (context, state) => const AIProductRecommendationPage(),
    ),
    GoRoute(
      path: '/category/:name',
      builder: (context, state) {
        final name = state.pathParameters['name'] ?? '';
        return CategoryPage(categoryName: name);
      },
    ),
    GoRoute(
      path: '/products/:category',
      builder: (context, state) {
        final category = state.pathParameters['category'] ?? 'All Products';
        return ProductListPage(category: category);
      },
    ),
    GoRoute(
      path: '/my-products',
      builder: (context, state) => const MyAddedProductsPage(),
    ),
  ],
);
