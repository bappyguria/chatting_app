import 'package:chatting_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendRequestScreen extends StatefulWidget {
  const FriendRequestScreen({super.key});

  @override
  _FriendRequestScreenState createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final firestore = FirebaseFirestore.instance;

  bool showRequests = false; // ✅ Toggle

  Future<void> acceptRequest(String requestId, String senderId) async {
    await firestore.collection('friends').doc(currentUser.uid).set({
      senderId: true
    }, SetOptions(merge: true));

    await firestore.collection('friends').doc(senderId).set({
      currentUser.uid: true
    }, SetOptions(merge: true));

    await firestore.collection('friend_requests').doc(requestId).update({
      'status': 'accepted',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showRequests ? "Friend Requests" : "Friends"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(
              showRequests ? Icons.group : Icons.person_add_alt_1,
            ),
            onPressed: () {
              setState(() {
                showRequests = !showRequests; // ✅ Toggle
              });
            },
          ),
        ],
      ),

      body: showRequests
          ? _buildRequestList()   // ✅ Show Friend Requests
          : _buildFriendsList(),  // ✅ Show Friends
    );
  }

  /// ✅ Friend Requests UI
  Widget _buildRequestList() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('friend_requests')
          .where('receiverId', isEqualTo: currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final requests = snapshot.data!.docs;

        return requests.isEmpty
            ? const Center(child: Text("No Friend Requests"))
            : ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];
            final data = req.data() as Map<String, dynamic>;
            final status = data['status'] ?? 'pending';
            final senderId = data['senderId'];
            final senderName = data['senderName'] ?? 'No Name';
            final senderEmail = data['senderEmail'] ?? '';

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(senderName[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                ),
                title: Text(senderName),
                subtitle: Text(senderEmail),
                trailing: status == 'pending'
                    ? ElevatedButton(
                  onPressed: () async {
                    await acceptRequest(req.id, senderId);
                  },
                  child: const Text("Accept"),
                )
                    : const Text("Accepted ✅"),
              ),
            );
          },
        );
      },
    );
  }

  /// ✅ Friends List UI
  Widget _buildFriendsList() {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestore.collection('friends').doc(currentUser.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final data = snapshot.data!.data() as Map<String, dynamic>?;

        if (data == null || data.isEmpty) {
          return const Center(child: Text("No Friends Yet"));
        }

        final friendIds = data.keys.toList();

        return ListView.builder(
          itemCount: friendIds.length,
          itemBuilder: (context, index) {
            final friendId = friendIds[index];

            return FutureBuilder<DocumentSnapshot>(
              future: firestore.collection('users').doc(friendId).get(),
              builder: (context, snap) {
                if (!snap.hasData) return const SizedBox();

                final user = snap.data!.data() as Map<String, dynamic>;
                final name = user['name'] ?? 'Unknown';
                final email = user['email'] ?? '';

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(name[0].toUpperCase()),
                    ),
                    title: Text(name),
                    subtitle: Text(email),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              peerId: friendId,
                              peerName: name,
                            ),
                          ),
                        );
                      },
                      child: const Text("Message"),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
