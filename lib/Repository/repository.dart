import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Repository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
/// Logs in a user with the provided email and password.
  Future<void> login({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
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
      'password': password,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// User List Stream
  Future<List<Map<String, dynamic>>> getUserList() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();

    if (snapshot.docs.isEmpty) return [];

    print(snapshot.docs);

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

}
