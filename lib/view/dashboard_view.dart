import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager_project/controller/auth_controller.dart';
import 'package:task_manager_project/controller/task_controller.dart';
import 'package:task_manager_project/model/attachment.dart';
import 'package:task_manager_project/view/about_view.dart';
import 'package:task_manager_project/view/account_settings_view.dart';
import 'package:task_manager_project/view/admin_view.dart';
import 'package:task_manager_project/view/attachment_view.dart';
import 'package:task_manager_project/view/privacy_view.dart';
import 'package:task_manager_project/view/task_view.dart';
import 'package:task_manager_project/view/profile_view.dart';
import 'package:task_manager_project/view/login_view.dart';
import 'package:task_manager_project/view/team_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final AuthController _authController = AuthController();
  final TaskController _taskController = TaskController();

  String? _userRole;
  double _taskProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    _loadTaskProgress();
  }

  void _loadUserRole() async {
    String? role = await _authController.getUserRole();
    setState(() {
      _userRole = role;
    });
  }

  void _loadTaskProgress() async {
    double progress = await _taskController.getUserTaskProgress();
    setState(() {
      _taskProgress = progress;
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Telekom Task Manager",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Welcome back!",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          _showSettingsMenu(context);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (_userRole != "admin")
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(64, 39, 84, 94),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 254, 254, 254)
                                .withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          if (_userRole != "admin")
                            const Text(
                              "Task Progress",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: _taskProgress,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                          const SizedBox(height: 5),
                          if (_userRole != "admin")
                            Text(
                              "${(_taskProgress * 100).toInt()}% Completed",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildDashboardButton(
                        context,
                        "View Tasks",
                        Icons.task_alt,
                        const Color.fromARGB(255, 255, 255, 255),
                        const TasksView(),
                      ),
                      _buildDashboardButton(
                        context,
                        "Profile",
                        Icons.person,
                        const Color.fromARGB(255, 255, 255, 255),
                        const ProfileView(),
                      ),
                      _buildDashboardButton(
                        context,
                        "Attachments",
                        Icons.attachment,
                        const Color.fromARGB(255, 255, 255, 255),
                        const AttachmentView(),
                      ),
                      _buildDashboardButton(
                        context,
                        "Team",
                        Icons.group,
                        const Color.fromARGB(255, 255, 255, 255),
                        const TeamView(),
                      ),
                      if (_userRole == "admin")
                        _buildDashboardButton(
                          context,
                          "Admin Panel",
                          Icons.admin_panel_settings,
                          const Color.fromARGB(255, 255, 255, 255),
                          const AdminPanelView(),
                        ),
                      _buildDashboardButton(
                        context,
                        "Logout",
                        Icons.logout,
                        Colors.grey,
                        null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context, String label,
      IconData icon, Color color, Widget? page) {
    return GestureDetector(
      onTap: () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        } else {
          _logoutUser(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _logoutUser(BuildContext context) async {
    await _authController.logoutUser();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false,
    );
  }

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Settings",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text("Support"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SupportPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text("Privacy & Security"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text("About"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutPage()));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
