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
      final response = await api.dio.get('/resorts');
      setState(() {
        resorts = response.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnack('Failed to fetch resorts');
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
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(resort['name']),
            subtitle: Text('${resort['location']} | Price: \$${resort['price']}'),
            leading: Image.network(resort['image'], width: 100, fit: BoxFit.cover),
            onTap: () {
              // Navigate to the resort details page
              // This can be a new screen that shows more details and allows booking
            },
          ),
        );
      },
    );
  }
}
