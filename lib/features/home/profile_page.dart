import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../core/api_client.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final api = ApiClient.create();
      final response = await api.dio.get('/users/me');
      setState(() {
        userProfile = response.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnack('Failed to fetch profile');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${userProfile?['firstName']} ${userProfile?['lastName']}'),
          const SizedBox(height: 12),
          Text('Email: ${userProfile?['email']}'),
          const SizedBox(height: 12),
          Text('Phone: ${userProfile?['phoneNumber']}'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Future functionality to update profile
            },
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }
}
