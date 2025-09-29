import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import 'package:go_router/go_router.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<dynamic> bookedResorts = [];  // List to store the resorts that the user has booked
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookedResorts();
  }

  Future<void> _fetchBookedResorts() async {
    try {
      final api = ApiClient.create();

      print('Fetching all resorts...');
      final resortResponse = await api.dio.get('/resorts');

      setState(() {
        bookedResorts = resortResponse.data ?? [];
        isLoading = false;
      });

      print('Fetched resorts count: ${bookedResorts.length}');
    } catch (e) {
      setState(() => isLoading = false);
      if (e is DioException) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
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
      itemCount: bookedResorts.length,
      itemBuilder: (context, index) {
        final resort = bookedResorts[index];
        final resortName = resort['name'] ?? 'Unknown Resort';
        final resortLocation = resort['location'] ?? 'Unknown Location';
        final pricePerNight = (resort['pricePerNight'] is num ? resort['pricePerNight'] : 0).toString();
        final rating = (resort['ratingAverage'] is num ? resort['ratingAverage'] : 0).toString();
        final images = resort['images'] ?? [];
        final imageUrl = images.isNotEmpty ? images[0] : 'https://via.placeholder.com/150';

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(resortName),
            subtitle: Text('$resortLocation | Price: \$${pricePerNight} | Rating: $rating'),
            leading: Image.network(imageUrl, width: 100, fit: BoxFit.cover),
            onTap: () {
              context.push('/resort_details', extra: resort);
            },

          ),
        );
      },
    );
  }
}
