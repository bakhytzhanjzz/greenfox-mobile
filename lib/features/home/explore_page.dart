import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../core/api_client.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<dynamic> resorts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchResorts();
  }

  Future<void> _fetchResorts() async {
    try {
      final api = ApiClient.create();
      final response = await api.dio.get('/resorts'); // Note: added /api prefix to match your Postman request

      setState(() {
        // The response data is already an array, not nested in a 'content' key
        resorts = response.data ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnack('Failed to fetch resorts: ${e.toString()}');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: resorts.length,
      itemBuilder: (context, index) {
        final resort = resorts[index];
        // Safe access with default values in case any field is null or mismatched
        final resortName = resort['name'] ?? 'Unknown Resort';
        final resortLocation = resort['location'] ?? 'Unknown Location';
        final pricePerNight = (resort['pricePerNight'] is num ? resort['pricePerNight'] : 0).toString(); // Safe numeric conversion
        final rating = (resort['ratingAverage'] is num ? resort['ratingAverage'] : 0).toString(); // Safe numeric conversion
        final images = resort['images'] ?? []; // Ensure images is never null
        final imageUrl = images.isNotEmpty ? images[0] : 'https://via.placeholder.com/150'; // Placeholder if no image

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(resortName),
            subtitle: Text('$resortLocation | Price: \$${pricePerNight} | Rating: $rating'),
            leading: Image.network(imageUrl, width: 100, fit: BoxFit.cover),
            onTap: () {
              // Navigate to the resort details page
              // You can pass the resort ID or the full resort data to the details page
              // context.push('/resort_details', extra: resort); // Example
            },
          ),
        );
      },
    );
  }
}
