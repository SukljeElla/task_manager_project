import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:task_manager_project/model/user.dart' as app_user;

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> createUser(app_user.User user) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      String uid = credential.user!.uid;
      await _database.child("users/$uid").set({
        'id': uid,
        'name': user.name,
        'email': user.email,
        'role': user.role ?? 'user',
      });

      print('User created successfully in Realtime Database!');
    } on FirebaseAuthException catch (e) {
      print('Error creating user: ${e.code}');
      rethrow;
    } catch (e) {
      print('Unexpected error creating user: $e');
      rethrow;
    }
  }

  Future<List<app_user.User>> getAllUsers() async {
    try {
      DatabaseEvent event = await _database.child("users").once();
      List<app_user.User> users = [];

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> userData =
            event.snapshot.value as Map<dynamic, dynamic>;

        userData.forEach((key, value) {
          try {
            users.add(app_user.User.fromJson(Map<String, dynamic>.from(value)));
          } catch (e) {
            print("Error parsing user data for $key: $e");
          }
        });
      }
      return users;
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<app_user.User?> getCurrentUser() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    DatabaseEvent event =
        await _database.child("users/${firebaseUser.uid}").once();
    if (event.snapshot.value != null) {
      Map<String, dynamic> userData =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      return app_user.User.fromJson(userData);
    }
    return null;
  }

  Future<app_user.User?> getUserById(String userId) async {
    DatabaseEvent event = await _database.child("users/$userId").once();
    if (event.snapshot.value != null) {
      Map<String, dynamic> userData =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      return app_user.User.fromJson(userData);
    }
    return null;
  }

  Future<String> getUserRole() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return "user";

    DatabaseEvent event =
        await _database.child("users/${firebaseUser.uid}/role").once();
    return event.snapshot.value as String? ?? "user";
  }

  Future<void> updateUser(app_user.User updatedUser) async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) throw Exception('User not logged in.');

    await _database.child("users/${firebaseUser.uid}").update({
      'name': updatedUser.name,
      'email': updatedUser.email,
      'role': updatedUser.role,
    });
  }

  Future<void> deleteUser() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) throw Exception('User not logged in.');

    await _database.child("users/${firebaseUser.uid}").remove();
    await firebaseUser.delete();
  }

  Future<void> deleteUserById(String userId) async {
    try {
      await _database.child("users/$userId").remove();
      print("User with ID $userId deleted successfully.");
    } catch (e) {
      print("Error deleting user: $e");
      rethrow;
    }
  }
}
