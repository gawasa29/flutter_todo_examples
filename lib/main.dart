import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_example/todo.dart';

GetIt getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<TodoState>(TodoState());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TodoState todoState = getIt<TodoState>();

    return ListenableBuilder(
      listenable: todoState,
      builder: (context, child) {
        List<TodoModel> todoList = todoState.todoModelList;
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Task Name',
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (BuildContext context, int index) {
                    TodoModel todo = todoList[index];
                    return ListTile(
                      title: Text(todo.text),
                      leading: Icon(
                        todo.completed
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                      ),
                      trailing: IntrinsicWidth(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                todoState.edit(
                                  id: todo.id,
                                  text: textEditingController.text,
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            TextButton(
                              onPressed: () => todoState.remove(todo.id),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                      onTap: () => todoState.toggle(todo.id),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              todoState.addTodo(textEditingController.text);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
