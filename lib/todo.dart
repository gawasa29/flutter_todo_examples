import 'package:flutter/material.dart';

@immutable
class TodoModel {
  const TodoModel({
    required this.text,
    this.completed = false,
  });

  final String text;
  final bool completed;

  TodoModel copyWith({String? text, bool? completed}) {
    return TodoModel(
      text: text ?? this.text,
      completed: completed ?? this.completed,
    );
  }
}

class TodoState extends ChangeNotifier {
  final void Function() rebuildPage;

  TodoState({required this.rebuildPage}) {
    addListener(rebuildPage);
  }

  final List<ValueNotifier<TodoModel>> _todoModelList = [];
  List<ValueNotifier<TodoModel>> get todoModelList => _todoModelList;

  void addTodo(String text) {
    final todo = ValueNotifier<TodoModel>(
      TodoModel(text: text),
    );
    _todoModelList.add(todo);
    notifyListeners();
  }

  void remove(int hashCode) {
    _todoModelList.removeWhere((todo) => todo.hashCode == hashCode);
    notifyListeners();
  }
}
