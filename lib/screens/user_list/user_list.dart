import 'package:chatting_app/screens/chat_screen.dart';
import 'package:chatting_app/screens/user_list/user_list_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    context.read<UserListBloc>().add(LoadUsersEvent());
  }

  Future<bool> checkFriend(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('friends')
        .doc(currentUser.uid)
        .get();

    return doc.data() != null && doc.data()!.containsKey(userId);
  }

  Future<bool> checkPending(String userId) async {
    final req = await FirebaseFirestore.instance
        .collection('friend_requests')
        .where('senderId', isEqualTo: currentUser.uid)
        .where('receiverId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .get();

    return req.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: BlocConsumer<UserListBloc, UserListState>(
        listener: (context, state) {
          if (state is UsersErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is UsersLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UsersLoadedState) {
            if (state.users.isEmpty) {
              return const Center(
                child: Text(
                  'No Users Found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = state.users[index];
                final userId = user["id"];

                if (userId == currentUser.uid) {
                  return const SizedBox.shrink(); // hide own account
                }

                return FutureBuilder(
                  future: Future.wait([
                    checkFriend(userId),
                    checkPending(userId),
                  ]),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const ListTile(
                        title: Text("Loading..."),
                        trailing: CircularProgressIndicator(),
                      );
                    }

                    final isFriend = snapshot.data[0];
                    final isPending = snapshot.data[1];

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            (user['name'] ?? 'U')[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          user['name'] ?? 'No Name',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(user['email'] ?? 'No Email'),

                        trailing: isFriend
                            ? ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  peerId: userId,
                                  peerName: user['name'],
                                ),
                              ),
                            );
                          },
                          child: const Text("Chat"),
                        )
                            : isPending
                            ? const Text(
                          "Pending",
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        )
                            : ElevatedButton(
                          onPressed: () async {

                            final userDoc = await FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentUser.uid)
                                .get();

                            final currentName = userDoc['name'] ?? 'No Name';
                            final currentEmail = userDoc['email'] ?? currentUser.email;

                            await FirebaseFirestore.instance
                                .collection('friend_requests')
                                .add({
                              'senderId': currentUser.uid,
                              'senderName': currentName,
                              'senderEmail': currentEmail,
                              'receiverId': userId,
                              'status': 'pending',
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                            setState(() {});

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Friend request sent")),
                            );
                          },

                          child: Icon(Icons.person),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
