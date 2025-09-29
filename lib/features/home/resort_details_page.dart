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
  int _currentImageIndex = 0;

  String _formatDate(DateTime d) => DateFormat('MMM dd, yyyy').format(d);
  String _formatApiDate(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  Future<void> _openBookingSheet() async {
    DateTime? checkIn;
    DateTime? checkOut;
    int guests = 1;
    final requestsController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setSheetState) {
          Future<void> pickCheckIn() async {
            final now = DateTime.now();
            final d = await showDatePicker(
              context: context,
              initialDate: checkIn ?? now,
              firstDate: now,
              lastDate: now.add(const Duration(days: 365)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: const Color(0xFF7BC74D),
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: const Color(0xFF1A2E25),
                    ),
                  ),
                  child: child!,
                );
              },
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
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: const Color(0xFF7BC74D),
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: const Color(0xFF1A2E25),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (d != null) setSheetState(() => checkOut = d);
          }

          int? nights = (checkIn != null && checkOut != null)
              ? checkOut!.difference(checkIn!).inDays
              : null;

          final pricePerNight = widget.resort['pricePerNight'] ?? 0;
          final totalPrice = nights != null ? pricePerNight * nights : null;

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Book Your Stay',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2E25),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Date Selection Cards
                  Row(
                    children: [
                      Expanded(
                        child: _DateCard(
                          label: 'Check-in',
                          date: checkIn,
                          onTap: pickCheckIn,
                          formatter: _formatDate,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DateCard(
                          label: 'Check-out',
                          date: checkOut,
                          onTap: pickCheckOut,
                          formatter: _formatDate,
                        ),
                      ),
                    ],
                  ),

                  if (nights != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5D8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.nights_stay_outlined,
                            size: 16,
                            color: Color(0xFF1B4D3E),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$nights ${nights == 1 ? 'night' : 'nights'}',
                            style: const TextStyle(
                              color: Color(0xFF1B4D3E),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Guests selector
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6F3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.person_outline, size: 20, color: Color(0xFF5A6F63)),
                            SizedBox(width: 8),
                            Text(
                              'Guests',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1A2E25),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 20),
                                color: guests > 1 ? const Color(0xFF7BC74D) : Colors.grey.shade400,
                                onPressed: guests > 1
                                    ? () => setSheetState(() => guests -= 1)
                                    : null,
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  '$guests',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A2E25),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 20),
                                color: const Color(0xFF7BC74D),
                                onPressed: () => setSheetState(() => guests += 1),
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Special requests
                  TextField(
                    controller: requestsController,
                    decoration: InputDecoration(
                      labelText: 'Special requests',
                      hintText: 'Any special requirements?',
                      prefixIcon: const Icon(Icons.message_outlined, size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF4F6F3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF7BC74D), width: 2),
                      ),
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 24),

                  // Price summary
                  if (totalPrice != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF7BC74D),
                            Color(0xFF5CAA3D),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Price',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2),
                            ],
                          ),
                          Text(
                            '₸${NumberFormat('#,###').format(totalPrice)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isBooking
                          ? null
                          : () async {
                        if (checkIn == null || checkOut == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please select check-in and check-out dates'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                          return;
                        }
                        if (!checkIn!.isBefore(checkOut!)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Check-in must be before check-out'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                          return;
                        }

                        setState(() => _isBooking = true);
                        try {
                          final api = ApiClient.create();
                          final payload = {
                            'resortId': widget.resort['id'],
                            'checkInDate': _formatApiDate(checkIn!),
                            'checkOutDate': _formatApiDate(checkOut!),
                            'guests': guests,
                            'specialRequests': requestsController.text.isNotEmpty
                                ? requestsController.text
                                : null,
                          };

                          await api.dio.post('/bookings', data: payload);

                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white),
                                  SizedBox(width: 12),
                                  Text('Booking confirmed successfully!'),
                                ],
                              ),
                              backgroundColor: const Color(0xFF6BBF59),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
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

                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor: const Color(0xFFE25C5C),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        } finally {
                          if (mounted) setState(() => _isBooking = false);
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF7BC74D),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isBooking
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        'Confirm Booking',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
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
    final imageUrl = images.isNotEmpty
        ? images[_currentImageIndex]
        : 'https://via.placeholder.com/800x400';

    final amenities = (resort['amenities'] as List<dynamic>?)?.cast<String>() ?? [];
    final pricePerNight = resort['pricePerNight'] ?? 0;
    final rating = resort['ratingAverage'] ?? 0.0;
    final ratingCount = resort['ratingCount'] ?? 0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero image with app bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.white,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2E25)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: Color(0xFF1A2E25)),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image, size: 80, color: Colors.grey),
                      );
                    },
                  ),
                  // Gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Image indicator
                  if (images.length > 1)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_currentImageIndex + 1}/${images.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main info card
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              resort['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A2E25),
                                letterSpacing: -0.5,
                                height: 1.2,
                              ),
                            ),
                          ),
                          if (rating > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7BC74D),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star, size: 16, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: Color(0xFF5A6F63),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              resort['location'] ?? '',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF5A6F63),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Reviews count
                      if (ratingCount > 0)
                        Text(
                          '$ratingCount ${ratingCount == 1 ? 'review' : 'reviews'}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9BA89F),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Price card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF7BC74D),
                              Color(0xFF5CAA3D),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7BC74D).withOpacity(0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Price per night',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₸${NumberFormat('#,###').format(pricePerNight)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -1,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Description
                      const Text(
                        'About',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2E25),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        resort['description'] ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF5A6F63),
                          height: 1.6,
                        ),
                      ),

                      if (amenities.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        const Text(
                          'Amenities',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A2E25),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: amenities.map((amenity) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F6F3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getAmenityIcon(amenity),
                                    size: 16,
                                    color: const Color(0xFF7BC74D),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    amenity,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF1A2E25),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],

                      if (resort['policies'] != null) ...[
                        const SizedBox(height: 32),
                        const Text(
                          'Policies',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A2E25),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F6F3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            resort['policies'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF5A6F63),
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: FilledButton(
          onPressed: _openBookingSheet,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF7BC74D),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Book Now',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    final lower = amenity.toLowerCase();
    if (lower.contains('wifi') || lower.contains('internet')) return Icons.wifi;
    if (lower.contains('pool')) return Icons.pool;
    if (lower.contains('parking')) return Icons.local_parking;
    if (lower.contains('gym') || lower.contains('fitness')) return Icons.fitness_center;
    if (lower.contains('spa')) return Icons.spa;
    if (lower.contains('restaurant') || lower.contains('food')) return Icons.restaurant;
    if (lower.contains('bar')) return Icons.local_bar;
    if (lower.contains('ac') || lower.contains('air')) return Icons.ac_unit;
    if (lower.contains('tv')) return Icons.tv;
    if (lower.contains('breakfast')) return Icons.free_breakfast;
    return Icons.check_circle_outline;
  }
}

class _DateCard extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final String Function(DateTime) formatter;

  const _DateCard({
    required this.label,
    required this.date,
    required this.onTap,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6F3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: date != null ? const Color(0xFF7BC74D) : Colors.grey.shade200,
            width: date != null ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5A6F63),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: date != null ? const Color(0xFF7BC74D) : const Color(0xFF9BA89F),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    date != null ? formatter(date!) : 'Select',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: date != null ? const Color(0xFF1A2E25) : const Color(0xFF9BA89F),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}