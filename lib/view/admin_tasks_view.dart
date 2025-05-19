import 'package:flutter/material.dart';
import 'package:task_manager_project/controller/task_controller.dart';
import 'package:task_manager_project/model/task.dart';

class ManageTasksView extends StatefulWidget {
  const ManageTasksView({Key? key}) : super(key: key);

  @override
  _ManageTasksViewState createState() => _ManageTasksViewState();
}

class _ManageTasksViewState extends State<ManageTasksView> {
  final TaskController _taskController = TaskController();
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    List<Task> fetchedTasks = await _taskController.getAllTasks();
    setState(() {
      _tasks = fetchedTasks;
      _isLoading = false;
    });
  }

  Future<void> _deleteTask(String taskId) async {
    bool confirmDelete = await _showConfirmDialog();
    if (confirmDelete) {
      await _taskController.deleteTask(taskId);
      _loadTasks();
    }
  }

  Future<bool> _showConfirmDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Task"),
        content: const Text(
          "Are you sure you want to delete this task? This action cannot be undone.",
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
          "Manage Tasks",
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
              : _tasks.isEmpty
                  ? const Center(
                      child: Text(
                        "No tasks available",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        Task task = _tasks[index];
                        return Card(
                          color: Colors.white.withOpacity(0.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            title: Text(
                              task.title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.description,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Assigned to: ${task.assignedTo.name}",
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 212, 215, 220),
                                      fontSize: 12),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Status: ${task.status}",
                                  style: TextStyle(
                                      color: _getStatusColor(task.status),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              onPressed: () => _deleteTask(task.id),
                            ),
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "On Working":
        return const Color.fromARGB(255, 6, 227, 239);
      case "Done":
        return const Color.fromARGB(204, 113, 229, 255);
      default:
        return const Color.fromARGB(255, 137, 218, 255);
    }
  }
}
