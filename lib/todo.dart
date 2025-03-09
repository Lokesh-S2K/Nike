import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _tasks = [];

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _tasks.add(_controller.text);
        _controller.clear();
      });
    }
  }

  void _editTask(int index) {
    _controller.text = _tasks[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Task"),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: "Enter task",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                setState(() {
                  _tasks[index] = _controller.text;
                  _controller.clear();
                });
                Navigator.pop(context);
              }
            },
            child: Text("Update", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do List", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildTextField()),
                SizedBox(width: 10),
                _buildAddButton(),
              ],
            ),
            SizedBox(height: 20),
            Expanded(child: _buildTaskList()),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: "Enter task",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: _addTask,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text("Add", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 5),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(_tasks[index], style: TextStyle(fontSize: 18)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editTask(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTask(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
