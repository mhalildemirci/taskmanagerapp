import 'package:flutter/material.dart';
import 'task.dart';

class AddTaskScreen extends StatefulWidget {
  final Function(Task) onAddTask;

  AddTaskScreen({required this.onAddTask});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _taskNameController = TextEditingController();
  final _taskDescriptionController = TextEditingController();
  DateTime? _selectedDate;

  void _submitTask() {
    if (_taskNameController.text.isEmpty || _selectedDate == null) {
      // Görev adı veya tarih boş bırakılmışsa uyarı verelim.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task Name and Date are required")),
      );
      return;
    }

    final task = Task(
      name: _taskNameController.text,
      description: _taskDescriptionController.text,
      dateTime: _selectedDate!,
      isCompleted: false,
    );

    widget.onAddTask(task);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Task")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(labelText: "Task Name*"),
            ),
            TextField(
              controller: _taskDescriptionController,
              decoration: InputDecoration(labelText: "Task Description"),
            ),
            SizedBox(height: 20),
            Text("Select Date*"),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? "No date chosen"
                        : "${_selectedDate!.toLocal()}".split(' ')[0],
                  ),
                ),
                ElevatedButton(
                  child: Text("Choose Date"),
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _selectedDate = selectedDate;
                      });
                    }
                  },
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _submitTask,
              child: Text("Add Task"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
