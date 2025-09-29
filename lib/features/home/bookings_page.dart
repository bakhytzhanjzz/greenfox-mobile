import 'package:flutter/material.dart';
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
      final response = await api.dio.get('/bookings/me'); // ✅ secure endpoint
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (bookings.isEmpty) {
      return const Center(child: Text("No bookings found"));
    }

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(
              booking['resortName'] ?? 'Unknown Resort',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Check-in: ${booking['checkInDate']}\n'
                  'Check-out: ${booking['checkOutDate']}\n'
                  'Guests: ${booking['guests']}\n'
                  'Status: ${booking['status']}',
            ),
            trailing: Text(
              '${booking['totalPrice']} ₸',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            onTap: () {
              // TODO: navigate to booking details page if needed
            },
          ),
        );
      },
    );
  }
}
