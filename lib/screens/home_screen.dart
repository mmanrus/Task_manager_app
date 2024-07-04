import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Task {
  final String task;

  Task(this.task);

  Map<String, dynamic> getMap() {
    return {'task': task};
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(map['task']);
  }

  static Task fromString(String task) {
    return Task(task);
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _taskController;
  late List<Task> _tasks;
  late List<bool> _taskDone;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();

    // Initialize tasks with example data
    _tasks = [
      Task('Example Task 1'),
      Task('Example Task 2'),
      Task('Example Task 3'),
    ];
    _taskDone = List.generate(_tasks.length, (index) => false);

    _getTasks(); // Fetch saved tasks
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Task t = Task.fromString(_taskController.text);

    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);
    list.add(t.getMap());
    prefs.setString('task', json.encode(list));

    _taskController.text = ''; // Clear the input field
    _getTasks(); // Refresh the task list
    Navigator.of(context).pop();
  }

  void _getTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);
    _tasks = list.map((d) => Task.fromMap(d as Map<String, dynamic>)).toList();
    _taskDone = List.generate(_tasks.length, (index) => false);
    setState(() {});
  }

  void updatePendingTaskList() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Task> pendingList = [];

    for (var i = 0 ; i < _tasks.length; i++) {
      if (!_taskDone[i]) pendingList.add(_tasks[i]);
    }
    var pendingListEncoded = List.generate(
        pendingList.length, (i) => json.encode(pendingList[i].getMap())
    );

    prefs.setString('task', json.encode(pendingListEncoded));

    _getTasks();
  }

  void _showDatePicker() {
    showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Screen',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: updatePendingTaskList,
              icon: Icon(Icons.save)
          ),
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('task', jsonEncode([]));

                _getTasks();
              },
              icon: Icon(Icons.delete)
          ),
        ],
        backgroundColor: Colors.blue[600], // Set your desired color here
      ),
      body: _tasks.isEmpty
          ? Center(child: Text('No Tasks'))
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Container(
            height: 70.0,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 5.0,
            ),
            padding: const EdgeInsets.only(left: 10.0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: Colors.black,
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(task.task),
                Checkbox(
                  value: _taskDone[index],
                  onChanged: (val) {
                    setState(() {
                      _taskDone[index] = val!;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[600],
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.blue[400],
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Add task', style: TextStyle(color: Colors.white)),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1.2,
                      color: Colors.black,
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter Task',
                      ),
                    ),

                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: Text('Reset'),
                            onPressed: () => _taskController.text = '',
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: ElevatedButton(
                            child: Text('Add'),
                            onPressed: () => saveData(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
