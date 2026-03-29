import 'package:flutter/material.dart';

class EP_Retail_Dashboard extends StatelessWidget {
  const EP_Retail_Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF1D262F),
        primaryColor: Color(0xFF1D262F),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                _buildSearchBar(),
                SizedBox(height: 20),
                Text(
                  "Welcome, Staff",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Store: TechPlumb Solutions",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                SizedBox(height: 20),
                _buildCategoryGrid(),
                SizedBox(height: 20),
                Text(
                  "Quick Buttons",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                _buildQuickButtons(),
                Spacer(), // Push content up, making room for any future bottom navigation
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFF1D262F),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.white60,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows),
              label: 'Compare',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFF2B3642),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white54),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Products...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Icon(Icons.qr_code_scanner, color: Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return SizedBox(
      height: 220, // Adjust as needed
      child: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        physics:
            NeverScrollableScrollPhysics(), // Prevent grid-within-column scroll
        children: [
          _buildCategoryItem("Electrical", Icons.bolt, Colors.amber[200]!),
          _buildCategoryItem(
            "Plumbing",
            Icons.water_drop,
            Colors.lightBlueAccent,
          ),
          _buildCategoryItem(
            "Lighting",
            Icons.lightbulb_outline,
            Colors.yellow,
          ),
          _buildCategoryItem("Pipes", Icons.stacked_bar_chart, Colors.grey),
          _buildCategoryItem(
            "Electrical",
            Icons.bolt,
            Colors.amber[200]!,
          ), // Second row example, re-using for spacing
          _buildCategoryItem("Pipes", Icons.stacked_bar_chart, Colors.grey),
          _buildCategoryItem("Switches", Icons.power, Colors.green),
          _buildCategoryItem(
            "Bathroom Fittings",
            Icons.bathtub_outlined,
            Colors.pinkAccent[100]!,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String label, IconData icon, Color iconColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xFF2B3642),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 28, color: iconColor),
        ),
        SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: Colors.white),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildQuickButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickButtonColumn("Product Search", Icons.manage_search_rounded),
        _buildQuickButtonColumn(
          "Compare Products",
          Icons.compare_arrows_rounded,
        ),
        _buildQuickButtonColumn("Scan Barcode", Icons.qr_code_scanner_rounded),
        _buildQuickButtonColumn(
          "Stock Check",
          Icons.check_circle_outline_rounded,
        ),
      ],
    );
  }

  Widget _buildQuickButtonColumn(String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, size: 30, color: Colors.blueAccent),
        ),
        SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ],
    );
  }
}
