import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  final TextEditingController _controller = TextEditingController();

  String bestProduct = '';
  String reason = '';
  String summary = '';
  bool isLoading = false;

  void getRecommendation() async {
    final input = _controller.text.trim();

    if (input.isEmpty) return;

    // Split comma separated input
    final barcodes = input.split(',');

    setState(() {
      isLoading = true;
    });

    try {
      final result =
          await ApiService().fetchComparisonData(barcodes);

      setState(() {
        bestProduct = result['data']['bestProduct'];
        reason = result['data']['reason'];
        summary = result['data']['summary'];
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching recommendation')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Recommendation')),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔹 Input Field
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter barcodes (comma separated)',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // 🔹 Button
            ElevatedButton(
              onPressed: isLoading ? null : getRecommendation,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Get Recommendation'),
            ),

            SizedBox(height: 30),

            // 🔹 Result Section
            if (bestProduct.isNotEmpty) ...[
              Text(
                "Best Product:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(bestProduct),

              SizedBox(height: 10),

              Text(
                "Reason:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(reason),

              SizedBox(height: 10),

              Text(
                "Summary:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(summary),
            ]
          ],
        ),
      ),
    );
  }
}