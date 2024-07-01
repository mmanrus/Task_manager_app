import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/task.dart';
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _taskController;
  late List<Task> _tasks;

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Task t = Task.fromString(_taskController.text);

    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);
    print(list);

    list.add(t.getMap());
    prefs.setString('task', json.encode(list));

    _taskController.text = ''; // Clear the input field
    Navigator.of(context).pop();
  }

  void _getTasks() async{
    _tasks = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasks = prefs.getString('task');


    List list = (tasks == null) ? [] : json.decode(tasks);
    for (Map<String, dynamic> d in list) {

      _tasks.add(Task.fromMap(json.decode(d as String)));
    }

    print(_tasks);
  }
  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();

    _getTasks();
  }
  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
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
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.blue[600], // Set your desired color here
      ),
      body: (_tasks == null) ? Center (
          child: Text('Task'),
      ) : Column (
        children: _tasks.map((e) => Container(
          height: 70.0,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 5.0
          ),
          padding: const EdgeInsets.only(
              left: 10.0,
          ),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.black,
              width: 0.5,
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(e.task),
            Checkbox(
              value: false,
              key: GlobalKey(), onChanged: (bool? value) {  },
            ),
          ],
          ), // Add style

        )
        )
            .toList()
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[600],
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Row(
            children: <Widget>[
              IconButton(
                tooltip: 'Open navigation menu',
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
              IconButton(
                tooltip: 'Search',
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                tooltip: 'Favorite',
                icon: const Icon(Icons.favorite),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}