import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_list/darktheme.dart';
import 'package:todos_list/todospage.dart';
import 'package:todos_list/calender.dart';

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

  final title = ["Todos", "Calendar", "Profile"];

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

  int _selectedBottomIndex = 0;

  Widget _counter(int num) {
    return Container(
      width: 20,
      height: 20,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          num.toString(),
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  int undoneNumber(String item) {
    List<Todo> filtered;
    filtered = _originalTodos
        .where((tile) => tile.category.contains(item) && tile.isChecked != true)
        .toList();
    return filtered.length.toInt();
  }

  int doneNumber(String item) {
    List<Todo> filtered;
    filtered = _originalTodos
        .where((tile) => tile.category.contains(item) && tile.isChecked == true)
        .toList();
    return filtered.length.toInt();
  }

  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    List<Todo> finishedTodos =
        _filteredTodos.where((check) => check.isChecked).toList();
    List<Todo> unfinishedTodos =
        _filteredTodos.where((check) => !check.isChecked).toList();
    int sliderValue = finishedTodos.length;
    int maxSliderValue = _originalTodos.length;
    int unfinished = unfinishedTodos.length;
    return Scaffold(
        appBar: AppBar(
          title: Text(title[_selectedBottomIndex]),
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
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedBottomIndex = index;
            });
          },
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                          side:
                              BorderSide(color: _stuff[index].color, width: 2),
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Unfinished'),
                              Divider(),
                            ],
                          ),
                        ),
                        if (unfinishedTodos.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: unfinishedTodos.length,
                            itemBuilder: (context, index) {
                              final todo = unfinishedTodos[index];
                              return Card(
                                color: Colors.white70,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ExpansionTile(
                                  leading: Checkbox(
                                    value: todo.isChecked,
                                    activeColor: _stuff
                                        .firstWhere((element) =>
                                            element.label == todo.category)
                                        .color,
                                    side: BorderSide(
                                        color: _stuff
                                            .firstWhere((element) =>
                                                element.label == todo.category)
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
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
                                ),
                              );
                            },
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Finished',
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                        if (finishedTodos.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: finishedTodos.length,
                            itemBuilder: (context, index) {
                              final todo = finishedTodos[index];
                              return Card(
                                color: Colors.white70,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ExpansionTile(
                                  leading: Checkbox(
                                    value: todo.isChecked,
                                    activeColor: _stuff
                                        .firstWhere((element) =>
                                            element.label == todo.category)
                                        .color,
                                    side: BorderSide(
                                        color: _stuff
                                            .firstWhere((element) =>
                                                element.label == todo.category)
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
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
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            CalendarPage(),
            Column(
              children: [
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(backgroundColor: Colors.grey),
                    title: const Text("Bete"),
                    subtitle: Text('Task finished: ${finishedTodos.length}'),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (final stuff in _stuff)
                        Card(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.316,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('${stuff.label}',
                                    style: const TextStyle(fontSize: 15)),
                                Text(
                                  '${doneNumber(stuff.label)}',
                                  style: TextStyle(
                                      color: stuff.color, fontSize: 35),
                                ),
                                const Text('Finished',
                                    style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: const SliderThemeData(
                            thumbShape:
                                RoundSliderThumbShape(disabledThumbRadius: 0),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 0),
                            disabledActiveTrackColor: Colors.yellow,
                            disabledInactiveTrackColor: Colors.grey,
                          ),
                          child: Slider(
                              min: 0,
                              max: maxSliderValue.toDouble(),
                              value: sliderValue.toDouble(),
                              onChanged: null),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          unfinished == 0
                              ? 'All tasks done'
                              : 'You still have $unfinished task(s) to do',
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
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
          currentIndex: _selectedBottomIndex,
          selectedItemColor: Colors.yellow,
          onTap: (int index) {
            setState(() {
              _selectedBottomIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  padding: const EdgeInsets.all(16.0),
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
                  title: const Text('Work'),
                  trailing: Visibility(
                      visible: undoneNumber('Work') != 0,
                      child: _counter(undoneNumber('Work')))),
              ListTile(
                  title: const Text('Routine'),
                  trailing: Visibility(
                      visible: undoneNumber('Routine') != 0,
                      child: _counter(undoneNumber('Routine')))),
              ListTile(
                  title: const Text('Others'),
                  trailing: Visibility(
                      visible: undoneNumber('Others') != 0,
                      child: _counter(undoneNumber('Others')))),
              const Divider(),
              ListTile(
                title: const Text('Dark Mode'),
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
        ));
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
