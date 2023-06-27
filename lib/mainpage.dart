import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_list/darktheme.dart';
import 'package:todos_list/todospage.dart';

void onSaveTodo(String title, String description, String startDate,
    String endDate, String category, BuildContext context) {
  final homePageState = context.findAncestorStateOfType<_MainPageState>();
  homePageState?.addTodo(title, description, startDate, endDate, category);
  Navigator.pop(context);
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Todo> _originalTodos = [];
  List<Todo> _filteredTodos = [];
  String? _value;
  final List<Stuff> _stuff = [
    Stuff('Work', Colors.red),
    Stuff('Routine', Colors.amber),
    Stuff('Others', Colors.blue)
  ];

  void addTodo(String title, String description, String startDate,
      String endDate, String category) {
    setState(() {
      _originalTodos.add(Todo(
        title: title,
        description: description,
        startDate: startDate,
        endDate: endDate,
        category: category,
        isChecked: false,
      ));
      _filteredTodos = _originalTodos;
    });
  }

  void _selectedChip(String? value) {
    List<Todo> filter;
    if (value != null) {
      filter = _originalTodos
          .where((tile) => tile.category.contains(value))
          .toList();
    } else {
      filter = _originalTodos;
    }
    setState(() {
      _filteredTodos = filter;
      _value = value;
    });
  }

  int _selectedButtomIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedButtomIndex = index;
    });
  }

  Widget _counter(int num) {
    return Container(
      width: 20,
      height: 20,
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          num.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  int doneNumber(String item) {
    List<Todo> filtered;
    filtered = _originalTodos
        .where((tile) => tile.category.contains(item) && tile.isChecked != true)
        .toList();
    return filtered.length.toInt();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          Icon(themeProvider.darkTheme == false
              ? Icons.wb_sunny
              : Icons.nightlight_round),
          Switch(
              value: themeProvider.darkTheme,
              onChanged: (value) {
                setState(() {
                  themeProvider.darkMode = value;
                });
              })
        ],
      ),
      body: Column(children: <Widget>[
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                spacing: 5.0,
                children: List<Widget>.generate(
                  _stuff.length,
                  (int index) {
                    return ChoiceChip(
                      label: Text(_stuff[index].label),
                      selectedColor: _stuff[index].color,
                      backgroundColor: Colors.white70,
                      side: BorderSide(color: _stuff[index].color, width: 2),
                      selected: _value == _stuff[index].label,
                      onSelected: (bool value) {
                        setState(() {
                          _value = value ? _stuff[index].label : null;
                        });

                        if (value) {
                          _selectedChip(_stuff[index].label);
                        } else {
                          _selectedChip(null);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredTodos.length,
            itemBuilder: (context, index) {
              final todo = _filteredTodos[index];
              return ExpansionTile(
                leading: Checkbox(
                  value: todo.isChecked,
                  activeColor: _stuff
                      .firstWhere((element) => element.label == todo.category)
                      .color,
                  side: BorderSide(
                      color: _stuff
                          .firstWhere(
                              (element) => element.label == todo.category)
                          .color,
                      width: 2),
                  onChanged: (bool? value) {
                    setState(() {
                      todo.isChecked = value ?? false;
                    });
                  },
                ),
                title: Text(
                  todo.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                subtitle: Text(
                  '${todo.startDate} s/d ${todo.endDate}',
                ),
                trailing: const Icon(Icons.arrow_drop_down),
                children: <Widget>[
                  ListTile(
                      title: Text(
                    todo.description,
                  )),
                ],
              );
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => Todos(onSaveTodo: addTodo))));
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Todos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined), label: 'Calender'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedButtomIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: themeProvider.darkTheme == false
                        ? Colors.yellow
                        : Colors.grey),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text('TODOS APP',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Text('By: BrianTanata')
                  ],
                )),
            ListTile(
                title: Text('Work'),
                trailing: Visibility(
                    visible: doneNumber('Work') != 0,
                    child: _counter(doneNumber('Work')))),
            ListTile(
                title: Text('Routine'),
                trailing: Visibility(
                    visible: doneNumber('Routine') != 0,
                    child: _counter(doneNumber('Routine')))),
            ListTile(
                title: Text('Others'),
                trailing: Visibility(
                    visible: doneNumber('Others') != 0,
                    child: _counter(doneNumber('Others')))),
            Divider(),
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                  value: themeProvider.darkTheme,
                  onChanged: (value) {
                    setState(() {
                      themeProvider.darkMode = value;
                    });
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class Stuff {
  String label;
  Color color;

  Stuff(this.label, this.color);
}

class Todo {
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String category;
  bool isChecked;

  Todo({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.category,
    this.isChecked = false,
  });
}
