import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Repository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
/// Logs in a user with the provided email and password.
  Future<void> login({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Get Current User Data
  Future<Map<String, dynamic>?> currentUserData() async {
    final user = _auth.currentUser;

    if (user == null) return null;

    DocumentSnapshot userDoc =
    await fireStore.collection('users').doc(user!.uid).get();

    if (userDoc.exists) {
      print("User Data: ${userDoc.data()}");
      return userDoc.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }


  /// Signs up a new user with the provided name, email, and password.
  Future<void> signUp({required String name,required String email, required String password}) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await fireStore.collection('users').doc(cred.user!.uid).set({
      'name': name,
      'email': email,
      'uid': cred.user!.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });

  }

  /// User List Stream
  Future<List<Map<String, dynamic>>> getUserList() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();

    if (snapshot.docs.isEmpty) return [];

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'name': data['name'] ?? '',
        'email': data['email'] ?? '',
      };
    }).toList();
  }


}
