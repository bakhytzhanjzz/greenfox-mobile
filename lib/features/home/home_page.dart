import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/session.dart';
import 'explore_page.dart'; // Import the explore page
import 'bookings_page.dart'; // Import the bookings page
import 'profile_page.dart'; // Import the profile

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Track the selected tab

  static const List<Widget> _pages = <Widget>[
    ExplorePage(), // Explore tab
    BookingsPage(), // Bookings tab
    ProfilePage(), // Profile tab
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GreenFox - Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle logout
              // Clear the session and navigate to login
              Session.instance.clear();
              context.go('/login');
            },
          ),
        ],
      ),
      body: _pages.elementAt(_selectedIndex), // Show the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'My Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
