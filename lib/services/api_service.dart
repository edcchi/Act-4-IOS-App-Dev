import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/task.dart';

class ApiService {
  static const String apiUrl = 'http://localhost:3000/tasks';

  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List).map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> createTask(Task task) async {
    await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'}, body: json.encode(task.toJson()));
  }

  Future<void> updateTask(Task task) async {
    await http.put(Uri.parse('$apiUrl/${task.id}'), headers: {'Content-Type': 'application/json'}, body: json.encode(task.toJson()));
  }

  Future<void> deleteTask(int id) async {
    await http.delete(Uri.parse('$apiUrl/$id'));
  }
}
