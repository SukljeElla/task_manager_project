import 'package:flutter/material.dart';
import 'package:task_manager_project/controller/user_controller.dart';
import 'package:task_manager_project/model/user.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({Key? key}) : super(key: key);

  @override
  _AdminUsersViewState createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  final UserController _userController = UserController();
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    List<User> users = await _userController.getAllUsers();
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  Future<void> _deleteUser(String userId) async {
    bool confirmDelete = await _showConfirmDialog();
    if (confirmDelete) {
      await _userController.deleteUserById(userId);
      _loadUsers();
    }
  }

  Future<bool> _showConfirmDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete User"),
        content: const Text(
          "Are you sure you want to delete this user? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manage Users",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(175, 8, 71, 87),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 86, 174, 201), Color(0xFF23233B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _users.isEmpty
                  ? const Center(
                      child: Text(
                        "No users found",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _users.length,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        User user = _users[index];
                        return Card(
                          color: Colors.white.withOpacity(0.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 30, 146, 176),
                              child: Text(
                                user.name[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              user.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.email,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Role: ${user.role}",
                                  style: TextStyle(
                                      color: _getRoleColor(user.role),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Color.fromARGB(205, 255, 255, 255)),
                              onPressed: () => _deleteUser(user.id),
                            ),
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case "admin":
        return const Color.fromARGB(255, 166, 255, 254);
      case "user":
        return const Color.fromARGB(255, 44, 211, 253);
      default:
        return Colors.white70;
    }
  }
}
