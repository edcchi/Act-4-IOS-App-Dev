import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final Function(Task) onUpdate;

  const EditTaskScreen({super.key, required this.task, required this.onUpdate});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;

  @override
  void initState() {
    super.initState();
    _title = widget.task.title;
    _description = widget.task.description;
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      widget.onUpdate(Task(
        id: widget.task.id,
        title: _title,
        description: _description,
        isComplete: widget.task.isComplete,
      ));
      Navigator.pop(context);
    }
  }

  void _cancelEdit() {
    Navigator.pop(context); // Return to the previous screen without saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Edit Task', style: GoogleFonts.poppins()),
        backgroundColor: Colors.grey[900],
      ),
      body: Center(
        child: Card(
          color: Colors.grey[850],
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: _title,
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: GoogleFonts.poppins(color: Colors.white70),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _title = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: _description,
                    style: GoogleFonts.poppins(color: Colors.white),
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: GoogleFonts.poppins(color: Colors.white70),
                      alignLabelWithHint: true,
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _description = value;
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _cancelEdit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey, // Grey background
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        child: const Text('Cancel', style: TextStyle(color: Colors.white)), // White text
                      ),
                      ElevatedButton(
                        onPressed: _saveTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        child: const Text('Save Task', style: TextStyle(color: Colors.black)), // Black text
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
