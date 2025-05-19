import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager_project/controller/task_controller.dart';
import 'package:task_manager_project/model/task.dart';
import 'package:task_manager_project/model/user.dart' as app_user;

class TasksView extends StatefulWidget {
  const TasksView({Key? key}) : super(key: key);

  @override
  _TasksViewState createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  final TaskController _taskController = TaskController();
  List<Task> _tasks = [];
  List<app_user.User> _users = [];
  String _userRole = "user";

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _userRole = await _taskController.getUserRole();

    if (_userRole == "admin") {
      _tasks = await _taskController.getAllTasks();
    } else {
      _tasks = await _taskController.getTasksForUser();
    }

    _users = await _taskController.getAllUsers();

    print("Loaded ${_tasks.length} tasks");
    setState(() {});
  }

  void _updateTaskStatus(String taskId, String status) async {
    await _taskController.updateTaskStatus(taskId, status);
    _loadTasks();
  }

  void _showCreateTaskModal(BuildContext context) {
    if (_userRole != "admin") return;

    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    app_user.User? selectedUser;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Create Task"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Title",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: "Description",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<app_user.User>(
                    value: selectedUser,
                    hint: const Text("Assign to"),
                    onChanged: (user) {
                      setState(() {
                        selectedUser = user!;
                      });
                    },
                    items: _users.map((user) {
                      return DropdownMenuItem(
                          value: user, child: Text(user.name));
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty &&
                        selectedUser != null) {
                      Task newTask = Task(
                        id: "",
                        title: titleController.text,
                        description: descriptionController.text,
                        assignedTo: selectedUser!,
                        createdBy: app_user.User(
                          id: FirebaseAuth.instance.currentUser!.uid,
                          name:
                              FirebaseAuth.instance.currentUser!.displayName ??
                                  "Admin",
                          email: FirebaseAuth.instance.currentUser!.email ??
                              "Unknown",
                          password: "",
                          role: "admin",
                          jobPosition: '',
                        ),
                        dueDate: DateTime.now(),
                        status: "Assigned",
                        comments: [],
                      );

                      await _taskController.createTask(newTask);
                      Navigator.pop(context);
                      _loadTasks();
                    }
                  },
                  child: const Text("Create"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _userRole == "admin"
          ? FloatingActionButton(
              onPressed: () => _showCreateTaskModal(context),
              backgroundColor: const Color.fromARGB(255, 9, 118, 148),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
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
                    "Tasks",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Pregled vseh opravil",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 235, 232, 232),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        Task task = _tasks[index];
                        return Card(
                          color: Colors.white.withOpacity(0.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            title: Text(task.title,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(task.description,
                                    style: const TextStyle(
                                        color: Color.fromARGB(
                                            255, 255, 255, 255))),
                                const SizedBox(height: 5),
                                Text("Assigned to: ${task.assignedTo.name}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 196, 239, 255),
                                        fontSize: 13)),
                                const SizedBox(height: 6),
                                Text("Status: ${task.status}",
                                    style: TextStyle(
                                        color: _getStatusColor(task.status),
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            trailing: _userRole == "admin"
                                ? null
                                : DropdownButton<String>(
                                    value: task.status,
                                    dropdownColor:
                                        const Color.fromARGB(255, 0, 0, 0),
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                    iconSize: 5,
                                    onChanged: (newStatus) {
                                      if (newStatus != null) {
                                        _updateTaskStatus(task.id, newStatus);
                                      }
                                    },
                                    items: ["Assigned", "On Working", "Done"]
                                        .map((status) {
                                      return DropdownMenuItem(
                                          value: status, child: Text(status));
                                    }).toList(),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case "On Working":
        return const Color.fromARGB(255, 33, 155, 192);
      case "Done":
        return const Color.fromARGB(232, 236, 251, 255);
      default:
        return const Color.fromARGB(255, 86, 174, 201);
    }
  }
}
