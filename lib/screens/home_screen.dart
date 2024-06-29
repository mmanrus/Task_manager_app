import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/task.dart';
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _taskController;

  void saveData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Task t = Task.fromString(_taskController.text);
    // prefs.setString('task', json.encode(t.getMap()));
    // _taskController.text = '';


  }
  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
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
      body:
      Center(
        child: Text('Task'),
      ),
      floatingActionButton: FloatingActionButton(
        child:  Icon(
        Icons.add
        ),
        backgroundColor: Colors.blue[600],
        onPressed: () => showModalBottomSheet (
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.blue[400],
              child: SizedBox.expand (
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add task'),
                      GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(Icons.close)
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
                        borderSide: BorderSide(color: Colors.blue)
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter Task',
                      //hind style to do
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    width: MediaQuery.of(context).size.width,
                    height: 200.0,
                    child: Row(
                      children: [
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 10,
                          child: ElevatedButton(
                            child: Text('Reset'),
                            onPressed: () => _taskController.text = '',
                          ),
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 10,
                          child: ElevatedButton(
                              child: Text('Add'),
                              onPressed: () => saveData(),
                          ),
                        ),
                      ],
                    ),
                  )
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