import 'package:flutter/material.dart';
import 'package:testpro26/main.dart';
import 'package:go_router/go_router.dart';

class AIProductRecommendationPage extends StatelessWidget {
  const AIProductRecommendationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Personal Assistant'),
        backgroundColor: Colors.orange[800],
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.auto_awesome, color: Colors.white)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAIBanner(),
            const SizedBox(height: 30),
            const Text(
              'Recommended for Your Shop',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const Text(
              'Based on your browsing history and recent trends.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            _buildRecommendationCard(
              context,
              'Havells Adonia R 25L',
              'Electrical',
              '98% Match',
              'Energy Efficient',
              Icons.bolt,
            ),
            _buildRecommendationCard(
              context,
              'Philips Hue Starter Kit',
              'Lighting',
              '95% Match',
              'Best for Ambiance',
              Icons.lightbulb_outline,
            ),
            _buildRecommendationCard(
              context,
              'Jaquar Sensor Faucet',
              'Bathroom',
              '92% Match',
              'Hygienic Choice',
              Icons.bathtub_outlined,
            ),
            const SizedBox(height: 30),
            _buildTrendingSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAIBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[800]!, Colors.orange[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.psychology, color: Colors.white, size: 60),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Recommendations',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Our smart engine has picked 12 new products for you.',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(
      BuildContext context, String name, String category, String match, String tag, IconData icon) {
    return GestureDetector(
      onTap: () {
        context.push('/product-details/890123456789');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
              child: Icon(icon, color: Colors.orange[800]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(category, style: TextStyle(color: Colors.orange[800], fontSize: 10, fontWeight: FontWeight.bold)),
                      Text(match, style: const TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
                    child: Text(tag, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trending in Your Area',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildTrendingTopic('Heavy Duty Pipes'),
              _buildTrendingTopic('Smart Lighting'),
              _buildTrendingTopic('Low Consumption Pumps'),
              _buildTrendingTopic('Modular Switches'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingTopic(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }
}
