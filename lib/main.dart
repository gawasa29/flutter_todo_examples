import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_example/todo.dart';

GetIt getIt = GetIt.instance;

void main() {
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
  void initState() {
    super.initState();
    getIt.registerSingleton<TodoState>(TodoState(rebuildPage: rebuildWidget));
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void rebuildWidget() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TodoState todoState = getIt<TodoState>();

    return ListenableBuilder(
      listenable: todoState,
      builder: (context, child) {
        final todoList = todoState.todoModelList;
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
                    final todo = todoList[index];
                    return TodoRow(
                      key: UniqueKey(),
                      todo: todo,
                      textEditingController: textEditingController,
                      onRemove: () => todoState.remove(todo.hashCode),
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

class TodoRow extends StatefulWidget {
  const TodoRow({
    super.key,
    required this.todo,
    required this.textEditingController,
    required this.onRemove,
  });

  final ValueNotifier<TodoModel> todo;
  final TextEditingController textEditingController;
  final void Function() onRemove;

  @override
  State<TodoRow> createState() => _TodoRowState();
}

class _TodoRowState extends State<TodoRow> {
  @override
  void initState() {
    super.initState();
    widget.todo.addListener(rebuild);
  }

  @override
  void dispose() {
    widget.todo.removeListener(rebuild);
    super.dispose();
  }

  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.todo.value.text),
      leading: Icon(
        widget.todo.value.completed ? Icons.check_box : Icons.check_box_outline_blank,
      ),
      trailing: IntrinsicWidth(
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                widget.todo.value = widget.todo.value.copyWith(text: widget.textEditingController.text);
              },
              icon: const Icon(Icons.edit),
            ),
            TextButton(
              onPressed: widget.onRemove,
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
      onTap: () => widget.todo.value = widget.todo.value.copyWith(completed: !widget.todo.value.completed),
    );
  }
}
