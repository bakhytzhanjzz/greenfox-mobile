import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import '../../theme/theme.dart';
import 'package:go_router/go_router.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<dynamic> bookedResorts = [];
  List<dynamic> filteredResorts = [];
  bool isLoading = true;
  String searchQuery = '';
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _fetchBookedResorts();
  }

  Future<void> _fetchBookedResorts() async {
    try {
      final api = ApiClient.create();
      final resortResponse = await api.dio.get('/resorts');

      setState(() {
        bookedResorts = resortResponse.data ?? [];
        filteredResorts = bookedResorts;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        _showSnack('Failed to fetch resorts');
      }
    }
  }

  void _filterResorts() {
    setState(() {
      filteredResorts = bookedResorts.where((resort) {
        final name = (resort['name'] ?? '').toString().toLowerCase();
        final location = (resort['location'] ?? '').toString().toLowerCase();
        final query = searchQuery.toLowerCase();

        final matchesSearch = name.contains(query) || location.contains(query);

        if (selectedFilter == 'All') return matchesSearch;
        if (selectedFilter == 'Top Rated') {
          final rating = resort['ratingAverage'] ?? 0;
          return matchesSearch && rating >= 4.0;
        }
        if (selectedFilter == 'Budget') {
          final price = resort['pricePerNight'] ?? 0;
          return matchesSearch && price < 150;
        }
        if (selectedFilter == 'Luxury') {
          final price = resort['pricePerNight'] ?? 0;
          return matchesSearch && price >= 200;
        }

        return matchesSearch;
      }).toList();
    });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern search header
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.primaryLight.withOpacity(0.05),
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Find your perfect eco-resort',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Search bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (value) {
                            searchQuery = value;
                            _filterResorts();
                          },
                          decoration: InputDecoration(
                            hintText: 'Search resorts or locations...',
                            prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                            suffixIcon: searchQuery.isNotEmpty
                                ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                setState(() {
                                  searchQuery = '';
                                  _filterResorts();
                                });
                              },
                            )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildFilterChip('All'),
                  _buildFilterChip('Top Rated'),
                  _buildFilterChip('Budget'),
                  _buildFilterChip('Luxury'),
                ],
              ),
            ),
          ),

          // Loading or content
          if (isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (filteredResorts.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No resorts found',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try adjusting your filters',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final resort = filteredResorts[index];
                    return _buildResortCard(resort);
                  },
                  childCount: filteredResorts.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedFilter = label;
            _filterResorts();
          });
        },
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildResortCard(Map<String, dynamic> resort) {
    final resortName = resort['name'] ?? 'Unknown Resort';
    final resortLocation = resort['location'] ?? 'Unknown Location';
    final pricePerNight = resort['pricePerNight'] ?? 0;
    final rating = (resort['ratingAverage'] ?? 0).toDouble();
    final images = resort['images'] ?? [];
    final imageUrl = images.isNotEmpty ? images[0] : 'https://via.placeholder.com/400x250';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/resort_details', extra: resort),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with gradient overlay
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: AppColors.surfaceVariant,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: AppColors.textTertiary,
                            ),
                          );
                        },
                      ),
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
                    // Rating badge
                    if (rating > 0)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Color(0xFFFFA726),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resortName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              resortLocation,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${pricePerNight.toString()}',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Text(
                                  '/night',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'View Details',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}