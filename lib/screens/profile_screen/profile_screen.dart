import 'package:chatting_app/screens/profile_screen/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),

      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded) {
            final user = state.userData;

            return Column(
              children: [
                const SizedBox(height: 30),

                // Profile Avatar Section
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepPurple.shade200,
                  child: Text(
                    user['name'][0].toUpperCase(),
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 10),
                Text(
                  user['name'] ?? "Unknown",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  user['email'] ?? "",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),

                const SizedBox(height: 30),

                // Card Details Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          profileRow(Icons.person, 'Name', user['name']),
                          const Divider(),
                          profileRow(Icons.email, 'Email', user['email']),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          }

          return const Center(child: Text("Failed to load profile", style: TextStyle(fontSize: 16)));
        },
      ),
    );
  }

  Widget profileRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
