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

  Future<void> _updateProfile(Map<String, dynamic> updated) async {
    try {
      final api = ApiClient.create();
      final response = await api.dio.put('/users/me', data: updated);
      setState(() {
        userProfile = response.data;
      });
      _showSnack('Profile updated successfully');
    } catch (e) {
      _showSnack('Failed to update profile');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _openEditDialog() {
    final firstNameController =
    TextEditingController(text: userProfile?['firstName'] ?? '');
    final lastNameController =
    TextEditingController(text: userProfile?['lastName'] ?? '');
    final emailController =
    TextEditingController(text: userProfile?['email'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: firstNameController, decoration: const InputDecoration(labelText: 'First Name')),
              TextField(controller: lastNameController, decoration: const InputDecoration(labelText: 'Last Name')),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                _updateProfile({
                  "firstName": firstNameController.text,
                  "lastName": lastNameController.text,
                  "email": emailController.text,
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProfile == null) {
      return const Center(child: Text('No profile data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  child: Text(
                    (userProfile?['firstName'] ?? 'U')[0],
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text("ID: ${userProfile?['id']}"),
              const SizedBox(height: 8),
              Text("Name: ${userProfile?['firstName']} ${userProfile?['lastName']}"),
              const SizedBox(height: 8),
              Text("Email: ${userProfile?['email']}"),
              const SizedBox(height: 8),
              Text("Phone: ${userProfile?['phoneNumber']}"),
              const SizedBox(height: 8),
              Text("Role: ${userProfile?['role']}"),
              const SizedBox(height: 8),
              Text("Created At: ${userProfile?['createdAt']}"),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _openEditDialog,
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
