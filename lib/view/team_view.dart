import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project/controller/user_controller.dart';
import 'package:task_manager_project/model/user.dart';

class TeamView extends StatefulWidget {
  const TeamView({Key? key}) : super(key: key);

  @override
  _TeamViewState createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Team",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _isLoading
                      ? const Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : _users.isEmpty
                          ? const Expanded(
                              child: Center(
                                child: Text(
                                  "No team members found.",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: _users.length,
                                padding: const EdgeInsets.all(10),
                                itemBuilder: (context, index) {
                                  User user = _users[index];
                                  return Card(
                                    color: Colors.white.withOpacity(0.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                      leading: CircleAvatar(
                                        backgroundColor: const Color.fromARGB(
                                            255, 30, 146, 176),
                                        child: Text(
                                          user.name.isNotEmpty
                                              ? user.name[0].toUpperCase()
                                              : "?",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      title: Text(
                                        user.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.email,
                                            style: const TextStyle(
                                                color: Colors.white70),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Position: ${user.jobPosition}",
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 2, 195, 248),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                              "User is admin: "
                                              "${user.email.contains("ella.suklje@gmail.com") != _users.contains("ella")}",
                                              style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 197, 196, 196),
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
