    // lib/features/home/resort_details_page.dart
    import 'package:flutter/material.dart';
    import '../../core/api_client.dart';
    import 'package:intl/intl.dart';
    import 'package:dio/dio.dart';


    class ResortDetailsPage extends StatefulWidget {
      final Map<String, dynamic> resort;

      const ResortDetailsPage({super.key, required this.resort});

      @override
      State<ResortDetailsPage> createState() => _ResortDetailsPageState();
    }

    class _ResortDetailsPageState extends State<ResortDetailsPage> {
      bool _isBooking = false;

      String _formatDate(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

      Future<void> _openBookingSheet() async {
        DateTime? checkIn;
        DateTime? checkOut;
        int guests = 1;
        final requestsController = TextEditingController();

        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) {
            // use StatefulBuilder so sheet has its own setState
            return StatefulBuilder(builder: (context, setSheetState) {
              Future<void> pickCheckIn() async {
                final now = DateTime.now();
                final d = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: now,
                  lastDate: now.add(const Duration(days: 365)),
                );
                if (d != null) setSheetState(() => checkIn = d);
              }

              Future<void> pickCheckOut() async {
                final start = checkIn ?? DateTime.now();
                final d = await showDatePicker(
                  context: context,
                  initialDate: start.add(const Duration(days: 1)),
                  firstDate: start.add(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 366)),
                );
                if (d != null) setSheetState(() => checkOut = d);
              }

              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Book Resort', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),

                      // check-in
                      ListTile(
                        title: const Text('Check-in'),
                        subtitle: Text(checkIn != null ? _formatDate(checkIn!) : 'Select date'),
                        trailing: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: pickCheckIn,
                        ),
                        onTap: pickCheckIn,
                      ),

                      // check-out
                      ListTile(
                        title: const Text('Check-out'),
                        subtitle: Text(checkOut != null ? _formatDate(checkOut!) : 'Select date'),
                        trailing: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: pickCheckOut,
                        ),
                        onTap: pickCheckOut,
                      ),

                      // guests
                      Row(
                        children: [
                          const Text('Guests:', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (guests > 1) setSheetState(() => guests -= 1);
                            },
                          ),
                          Text('$guests', style: const TextStyle(fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => setSheetState(() => guests += 1),
                          ),
                        ],
                      ),

                      // special requests
                      TextField(
                        controller: requestsController,
                        decoration: const InputDecoration(labelText: 'Special requests (optional)'),
                        maxLines: 2,
                      ),

                      const SizedBox(height: 16),

                      // confirm button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isBooking
                              ? null
                              : () async {
                            // simple validation
                            if (checkIn == null || checkOut == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please select check-in and check-out dates')),
                              );
                              return;
                            }
                            if (!checkIn!.isBefore(checkOut!)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Check-in must be before check-out')),
                              );
                              return;
                            }

                            setState(() => _isBooking = true);
                            try {
                              final api = ApiClient.create();
                              final payload = {
                                'resortId': widget.resort['id'],
                                'checkInDate': _formatDate(checkIn!),
                                'checkOutDate': _formatDate(checkOut!),
                                'guests': guests,
                                'specialRequests': requestsController.text.isNotEmpty ? requestsController.text : null,
                              };

                              final resp = await api.dio.post('/bookings', data: payload);

                              // success
                              Navigator.of(context).pop(); // close bottom sheet
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Booking successful')),
                              );
                            } catch (err) {
                              String message = 'Failed to create booking';
                              if (err is DioException) {
                                final data = err.response?.data;
                                if (data is Map && data['message'] != null) {
                                  message = data['message'].toString();
                                } else if (err.message != null) {
                                  message = err.message!;
                                }
                              } else {
                                message = err.toString();
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message)),
                              );
                            } finally {
                              setState(() => _isBooking = false);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: _isBooking ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Confirm Booking'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            });
          },
        );
      }

      @override
      Widget build(BuildContext context) {
        final resort = widget.resort;
        final images = (resort['images'] as List<dynamic>?)?.cast<String>() ?? [];
        final imageUrl = images.isNotEmpty ? images[0] : 'https://via.placeholder.com/800x400';

        final amenities = (resort['amenities'] as List<dynamic>?)?.cast<String>() ?? [];

        return Scaffold(
          appBar: AppBar(title: Text(resort['name'] ?? 'Resort')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(imageUrl, height: 220, width: double.infinity, fit: BoxFit.cover),
                const SizedBox(height: 12),
                Text(resort['name'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(resort['location'] ?? '', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Price: ${resort['pricePerNight'] ?? '-'} ₸', style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 12),
                    Text('Rating: ${resort['ratingAverage'] ?? '-'} (${resort['ratingCount'] ?? 0})'),
                  ],
                ),
                const SizedBox(height: 12),
                Text(resort['description'] ?? ''),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: amenities.map((a) => Chip(label: Text(a))).toList(),
                ),
                const SizedBox(height: 12),
                Text('Policies', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(resort['policies'] ?? '-'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _openBookingSheet,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Book Now'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
