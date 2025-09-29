import 'package:flutter/foundation.dart';
import '../models/todo_item.dart';

class TodoProvider with ChangeNotifier {
  final List<TodoItem> _todoItems = [];

  List<TodoItem> get allTodos => List.unmodifiable(_todoItems);
  List<TodoItem> get completedTodos =>
      _todoItems.where((item) => item.isCompleted).toList();
  List<TodoItem> get pendingTodos =>
      _todoItems.where((item) => !item.isCompleted).toList();
  int get totalCount => _todoItems.length;
  int get completedCount => completedTodos.length;
  int get pendingCount => pendingTodos.length;

  void addTodo(String text) {
    if (text.trim().isEmpty) return;

    _todoItems.add(TodoItem(text: text.trim(), createdAt: DateTime.now()));
    notifyListeners();
  }

  void toggleTodoStatus(String id) {
    final index = _todoItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _todoItems[index] = _todoItems[index].copyWith(
        isCompleted: !_todoItems[index].isCompleted,
        completedAt: !_todoItems[index].isCompleted ? DateTime.now() : null,
      );
      notifyListeners();
    }
  }

  void updateTodoText(String id, String newText) {
    final index = _todoItems.indexWhere((item) => item.id == id);
    if (index != -1 && newText.trim().isNotEmpty) {
      _todoItems[index] = _todoItems[index].copyWith(text: newText.trim());
      notifyListeners();
    }
  }

  void deleteTodo(String id) {
    _todoItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCompleted() {
    _todoItems.removeWhere((item) => item.isCompleted);
    notifyListeners();
  }
}
