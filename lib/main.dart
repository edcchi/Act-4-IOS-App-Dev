import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' as google_fonts;
import 'models/edit_task.dart';
import 'models/task.dart';
import 'services/api_service.dart';

void main() => runApp(const ToDoApp());

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[900],
        textTheme: google_fonts.GoogleFonts.poppinsTextTheme(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = []; // Local list to store tasks

  @override
  void initState() {
    super.initState();
    _fetchTasks(); // Fetch tasks when the widget is initialized
  }

  void _fetchTasks() {
    ApiService().fetchTasks().then((tasks) {
      setState(() {
        _tasks = tasks; // Update the local list with fetched tasks
      });
    });
  }

  void _addTask() {
    Task newTask = Task(id: 0, title: '', description: '', isComplete: false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(
          task: newTask,
          onUpdate: (updatedTask) {
            ApiService().createTask(updatedTask).then((_) {
              setState(() {
                _tasks.add(updatedTask); // Add new task to local list
              });
            });
          },
        ),
      ),
    );
  }

  void _updateTask(Task task) {
    ApiService().updateTask(task).then((_) {
      setState(() {
        int index = _tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          _tasks[index] = task; // Update the task in the local list
        }
      });
    });
  }

  void _confirmDeleteTask(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        title: const Text(
          'Delete Task',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this task?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              _deleteTask(id); // Proceed to delete task
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteTask(int id) {
    ApiService().deleteTask(id).then((_) {
      setState(() {
        _tasks.removeWhere((task) => task.id == id); // Remove the deleted task from the local list
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task: $error')),
      );
    });
  }

  void _editTask(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(
          task: task,
          onUpdate: (updatedTask) {
            _updateTask(updatedTask);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('To-Do List', style: google_fonts.GoogleFonts.poppins(
          fontSize: 27,
          fontWeight: FontWeight.bold
        ), // Apply Poppins font here
  ),
  centerTitle: true,
  backgroundColor: Colors.grey[900],
),

      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks yet!', style: TextStyle(color: Colors.white)))
          : ListView(
              children: _tasks.map((task) {
                return ListTile(
                  title: Text(task.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(task.description, style: const TextStyle(color: Colors.grey)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _confirmDeleteTask(task.id), // Show confirmation dialog
                  ),
                  onTap: () => _editTask(task),
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: Colors.grey[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
