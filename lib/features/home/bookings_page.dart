import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../core/api_client.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  List<dynamic> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      final api = ApiClient.create();
      final response = await api.dio.get('/bookings');
      setState(() {
        bookings = response.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnack('Failed to fetch bookings');
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
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(booking['resortName']),
            subtitle: Text('Booked: ${booking['date']}'),
            onTap: () {
              // Navigate to booking details (if any more details needed)
            },
          ),
        );
      },
    );
  }
}
