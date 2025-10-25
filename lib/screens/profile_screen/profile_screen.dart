import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  File? _image;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user == null) return;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
      await uploadImageToFirebase();
    }
  }

  Future<void> uploadImageToFirebase() async {
    if (_image == null) return;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_photos/${user!.uid}.jpg');

      await storageRef.putFile(_image!);
      final downloadUrl = await storageRef.getDownloadURL();

      // Firestore এ ইউজার ডকুমেন্টে imageUrl আপডেট
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'imageUrl': downloadUrl});

      setState(() {
        userData?['imageUrl'] = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile photo updated successfully!")),
      );
    } catch (e) {
      print("Upload error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.deepPurple.shade100,
                  backgroundImage: userData?['imageUrl'] != null
                      ? NetworkImage(userData!['imageUrl'])
                      : (_image != null ? FileImage(_image!) : null)
                  as ImageProvider?,
                  child: userData?['imageUrl'] == null && _image == null
                      ? const Icon(Icons.camera_alt,
                      size: 40, color: Colors.deepPurple)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Text("Name: ${userData?['name'] ?? 'N/A'}",
                  style: const TextStyle(fontSize: 18)),
              Text("Email: ${userData?['email'] ?? 'N/A'}",
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text("UID: ${user!.uid}", style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
