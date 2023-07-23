import 'dart:math';

import 'package:flutter/material.dart';

@immutable
class TodoModel {
  const TodoModel({
    required this.id,
    required this.text,
    this.completed = false,
  });

  final String id;
  final String text;
  final bool completed;

  TodoModel copyWith({String? id, String? text, bool? completed}) {
    return TodoModel(
      id: id ?? this.id,
      text: text ?? this.text,
      completed: completed ?? this.completed,
    );
  }
}

class TodoState extends ChangeNotifier {
  List<TodoModel> _todoModelList = [];
  List<TodoModel> get todoModelList => _todoModelList;

  void addTodo(String text) {
    _todoModelList.add(
      TodoModel(
        id: Random().nextDouble().toString(),
        text: text,
      ),
    );
    notifyListeners();
  }

  void toggle(String id) {
    _todoModelList = [
      for (final todo in _todoModelList)
        if (todo.id == id) todo.copyWith(completed: !todo.completed) else todo,
    ];
    notifyListeners();
  }

  void edit({required String id, required String text}) {
    _todoModelList = [
      for (final todo in _todoModelList)
        if (todo.id == id) todo.copyWith(text: text) else todo,
    ];
    notifyListeners();
  }

  void remove(String todoId) {
    _todoModelList.removeWhere((todo) => todo.id == todoId);
    notifyListeners();
  }
}
