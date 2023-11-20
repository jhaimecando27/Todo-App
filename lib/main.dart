import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const ToDo());
}

class ToDo extends StatelessWidget {
  const ToDo({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

// Manages Changes in the system
class MyAppState extends ChangeNotifier {
  var tasks = {};

  void addTask(String task) {
    tasks[task] = false;

    notifyListeners();
  }

  void toggleTask(String task, value) {
    tasks[task] = !value;
    notifyListeners();
  }

  void deleteTask(String task) {
    tasks.remove(task);

    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('To Do'),
          centerTitle: true,
        ),
        body: const ListTasks(),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Form(
            key: formKey,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some task';
                      }

                      if (appState.tasks.containsKey(value)) {
                        return 'Task already existed';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      appState.addTask(controller.text);
                    }
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ListTasks extends StatefulWidget {
  const ListTasks({
    super.key,
  });

  @override
  State<ListTasks> createState() => _ListTasksState();
}

class _ListTasksState extends State<ListTasks> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      children: [
        for (var task in appState.tasks.keys)
          if (appState.tasks[task] == false)
            ListTile(
              leading: Checkbox(
                value: appState.tasks[task],
                onChanged: (bool? value) {
                  appState.toggleTask(task, value);
                },
              ),
              title: Text(task),
              onTap: () {
                appState.toggleTask(task, appState.tasks[task]);
              },
              trailing: TextButton(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Confirmation'),
                    content: Text('Delete this task?\nTask: "$task"'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          appState.deleteTask(task);
                          Navigator.pop(context, 'Ok');
                        },
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.red),
                          foregroundColor:
                              MaterialStatePropertyAll<Color>(Colors.white),
                        ),
                        child: const Text('Delete'),
                      )
                    ],
                  ),
                ),
                child: const Icon(Icons.delete),
              ),
            ),
        for (var task in appState.tasks.keys)
          if (appState.tasks[task] == true)
            ListTile(
              leading: Checkbox(
                value: appState.tasks[task],
                onChanged: (bool? value) {
                  appState.toggleTask(task, value);
                },
              ),
              title: Text(task),
              textColor: Colors.black.withOpacity(0.4),
              onTap: () {
                appState.toggleTask(task, appState.tasks[task]);
              },
              trailing: TextButton(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Confirmation'),
                    content: Text('Delete this task?\nTask: "$task"'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          appState.deleteTask(task);
                          Navigator.pop(context, 'Ok');
                        },
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.red),
                          foregroundColor:
                              MaterialStatePropertyAll<Color>(Colors.white),
                        ),
                        child: const Text('Delete'),
                      )
                    ],
                  ),
                ),
                child: const Icon(Icons.delete),
              ),
            ),
      ],
    );
  }
}
