import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:task_manager_project/model/task.dart';
import 'package:task_manager_project/model/user.dart' as app_user;

class TaskController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getUserRole() async {
    String uid = _auth.currentUser?.uid ?? "";
    if (uid.isEmpty) return "user";

    DatabaseEvent event = await _database.child("users/$uid/role").once();
    return event.snapshot.value as String? ?? "user";
  }

  Future<List<app_user.User>> getAllUsers() async {
    try {
      DatabaseEvent event = await _database.child("users").once();
      List<app_user.User> users = [];

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> userData =
            event.snapshot.value as Map<dynamic, dynamic>;
        userData.forEach((key, value) {
          users.add(app_user.User.fromJson(Map<String, dynamic>.from(value)));
        });
      }
      return users;
    } catch (e) {
      print('Error fetching users: $e');
      rethrow;
    }
  }

  Future<void> createTask(Task task) async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser == null) throw Exception("User not logged in.");

      String userRole = await getUserRole();
      if (userRole != "admin")
        throw Exception("You do not have permission to create tasks.");

      DatabaseReference taskRef = _database.child("tasks").push();
      await taskRef.set({
        'id': taskRef.key,
        'title': task.title,
        'description': task.description,
        'assignedTo': task.assignedTo.toJson(),
        'createdBy': task.createdBy.toJson(),
        'dueDate': task.dueDate.toIso8601String(),
        'status': task.status,
        'comments': task.comments.map((comment) => comment.toJson()).toList(),
      });

      print("Task created successfully!");
    } catch (e) {
      print('Error creating task: $e');
      rethrow;
    }
  }

  Future<List<Task>> getTasksForUser() async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
      if (uid.isEmpty) return [];

      DatabaseEvent event = await FirebaseDatabase.instance
          .ref()
          .child("tasks")
          .orderByChild("assignedTo/id")
          .equalTo(uid)
          .once();

      List<Task> tasks = [];

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> taskData =
            event.snapshot.value as Map<dynamic, dynamic>;

        taskData.forEach((key, value) {
          try {
            Map<String, dynamic> parsedValue =
                Map<String, dynamic>.from(value as Map);

            tasks.add(Task.fromJson(parsedValue));
          } catch (e) {
            print('Error parsing task: $e');
          }
        });
      }

      print("Fetched ${tasks.length} tasks");
      return tasks;
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  Future<void> updateTaskStatus(String taskId, String status) async {
    try {
      await _database.child("tasks/$taskId/status").set(status);
      print("Task status updated to: $status");
    } catch (e) {
      print('Error updating task status: $e');
      rethrow;
    }
  }

  Future<double> getUserTaskProgress() async {
    try {
      String uid = _auth.currentUser?.uid ?? "";
      if (uid.isEmpty) return 0.0;

      DatabaseEvent event = await _database
          .child("tasks")
          .orderByChild("assignedTo/id")
          .equalTo(uid)
          .once();

      int totalTasks = 0;
      int completedTasks = 0;

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> taskData =
            event.snapshot.value as Map<dynamic, dynamic>;

        taskData.forEach((key, value) {
          Map<String, dynamic> parsedValue =
              Map<String, dynamic>.from(value as Map);
          Task task = Task.fromJson(parsedValue);
          totalTasks++;
          if (task.status == "Done") {
            completedTasks++;
          }
        });
      }

      if (totalTasks == 0) return 0.0;
      return completedTasks / totalTasks;
    } catch (e) {
      print('Error fetching task progress: $e');
      return 0.0;
    }
  }

  Future<List<Task>> getAllTasks() async {
    try {
      DatabaseEvent event = await _database.child("tasks").once();
      List<Task> tasks = [];

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> taskData =
            event.snapshot.value as Map<dynamic, dynamic>;

        taskData.forEach((key, value) {
          try {
            Map<String, dynamic> parsedValue =
                Map<String, dynamic>.from(value as Map);
            tasks.add(Task.fromJson(parsedValue));
          } catch (e) {
            print('Error parsing task: $e');
          }
        });
      }

      print("Fetched ${tasks.length} tasks");
      return tasks;
    } catch (e) {
      print('Error fetching all tasks: $e');
      return [];
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _database.child("tasks/$taskId").remove();
      print("Task deleted successfully!");
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }
}
