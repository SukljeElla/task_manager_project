import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<String?> registerUser(
      String name, String surname, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user!.uid;

      await _database.child('users/$uid').set({
        'id': uid,
        'name': name,
        'surname': surname,
        'email': email,
        'role': 'user',
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<String?> getUserRole() async {
    User? user = _auth.currentUser;
    if (user == null) return null;

    DatabaseEvent snapshot =
        await _database.child('users/${user.uid}/role').once();
    return snapshot.snapshot.value.toString();
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
  }
}
