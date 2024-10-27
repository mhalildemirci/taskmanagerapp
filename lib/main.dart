import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/AddTaskScreen.dart';
import 'task.dart';

void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatefulWidget {
  @override
  _TaskManagerAppState createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
          titleTextStyle: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black87,
          titleTextStyle: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      home: TaskListScreen(toggleTheme: _toggleTheme, themeMode: _themeMode),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  TaskListScreen({required this.toggleTheme, required this.themeMode});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  Task? _recentlyDeletedTask;
  int? _recentlyDeletedTaskIndex;

  void _addNewTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _recentlyDeletedTask = tasks[index];
      _recentlyDeletedTaskIndex = index;
      tasks.removeAt(index);
    });

    // Kullanıcıya görevin silindiğini ve geri alabileceğini gösteren bir SnackBar gösterelim
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${_recentlyDeletedTask?.name} deleted"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            _undoDelete();
          },
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _undoDelete() {
    setState(() {
      if (_recentlyDeletedTask != null && _recentlyDeletedTaskIndex != null) {
        tasks.insert(_recentlyDeletedTaskIndex!, _recentlyDeletedTask!);
        _recentlyDeletedTask = null;
        _recentlyDeletedTaskIndex = null;
      }
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager',
            style:
                GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Icon(widget.themeMode == ThemeMode.light
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: tasks.isEmpty
          ? Center(child: Text('Add a new task by clicking the Add button'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Dismissible(
                  key: Key(task.name),
                  onDismissed: (direction) {
                    _deleteTask(index);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(
                      task.name,
                      style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                    subtitle: Text("${task.description} - ${task.dateTime}"),
                    trailing: Checkbox(
                      value: task.isCompleted,
                      onChanged: (bool? value) {
                        _toggleTaskCompletion(index);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(onAddTask: _addNewTask),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
