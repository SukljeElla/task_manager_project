import 'package:flutter/material.dart';
import 'package:task_manager_project/controller/user_controller.dart';
import 'package:task_manager_project/controller/ticket_controller.dart';
import 'package:task_manager_project/controller/task_controller.dart';
import 'package:task_manager_project/view/admin_tasks_view.dart';
import 'package:task_manager_project/view/admin_tickets_view.dart';
import 'package:task_manager_project/view/admin_user_view.dart';
import 'package:task_manager_project/view/attachment_view.dart';

class AdminPanelView extends StatelessWidget {
  const AdminPanelView({Key? key}) : super(key: key);

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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Admin Dashboard",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        _buildAdminButton(
                          context,
                          "Manage Users",
                          Icons.person,
                          const Color.fromARGB(255, 255, 255, 255),
                          const AdminUsersView(),
                        ),
                        _buildAdminButton(
                          context,
                          "Manage Tickets",
                          Icons.support,
                          const Color.fromARGB(255, 215, 232, 246),
                          const AdminTicketsView(),
                        ),
                        _buildAdminButton(
                          context,
                          "Manage Tasks",
                          Icons.task_alt,
                          const Color.fromARGB(255, 218, 243, 250),
                          const ManageTasksView(),
                        ),
                        _buildAdminButton(
                          context,
                          "Manage Attachments",
                          Icons.attachment,
                          const Color.fromARGB(255, 223, 248, 255),
                          const AttachmentView(),
                        ),
                      ],
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

  Widget _buildAdminButton(BuildContext context, String label, IconData icon,
      Color color, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
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
}
