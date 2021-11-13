import 'package:flutter/foundation.dart';

import 'models/models.dart';

export 'models/todo.dart';
export 'models/todos_filter.dart';

class AppState with ChangeNotifier {
  final todosRepository = TodosRepository();

  /// Id of logged-in user who can access his todos only.
  final userId = 1;

  /// Options for filtering the [todos] list. Default to [showAll].
  var _todosFilter = TodosFilter.showAll;
  set todosFilter(TodosFilter value) {
    _todosFilter = value;
    notifyListeners();
  }

  /// True when [Todo] deletion is in progress.
  var _inProgress = false;
  bool get inProgress => _inProgress;

  /// In-memory [todos] which are initially null when the app starts.
  List<Todo>? todos;

  /// Data for displaying the todos list.
  Future<List<Todo>> get futureTodos => fetchTodos();

  /// Returns data for displaying todos list.
  ///
  /// Data are read from repository only once when
  /// in-memory [todos] are null at app start.
  Future<List<Todo>> fetchTodos() async {
    todos = todos ?? await todosRepository.readAllTodos(userId);

    // Filter in-memory data based on user's choice.
    switch (_todosFilter) {
      case TodosFilter.showAll:
        return todos!;
      case TodosFilter.showActive:
        return todos!.where((todo) => !todo.isCompleted).toList();
      case TodosFilter.showCompleted:
        return todos!.where((todo) => todo.isCompleted).toList();
    }
  }

  Future<void> create(Todo todo) async {
    // Persists data in repository and get a new data id.
    final newTodo = await todosRepository.create(todo, userId);
    // Updates in-memory data.
    todos!.add(newTodo);
    // Tells the view to update.
    notifyListeners();
  }

  Future<void> toggleCompletion(Todo todo) async {
    // Updates in-memory data.
    todo.isCompleted = !todo.isCompleted;
    // Persists data in repository.
    await todosRepository.update(todo);
    // Tells the view to update.
    notifyListeners();
  }

  Future<void> update(Todo todo) async {
    // Persists data in repository.
    await todosRepository.update(todo);
    // Tells the view to update.
    notifyListeners();
  }

  Future<void> deleteCompletedTodos() async {
    _inProgress = true;
    // Tells the view to show a progress indicator.
    notifyListeners();
    // Deletes data in repository.
    for (final todo in todos!.where((todo) => todo.isCompleted)) {
      await todosRepository.delete(todo);
    }
    // Update in-memory data.
    todos!.removeWhere((todo) => todo.isCompleted);
    _inProgress = false;
    // Tells the view to update.
    notifyListeners();
  }
}

// Learning points of CRUD.
// Each operation involves two sources of the same data:
// in-memory and repository.
// The initial read operation loads data from repository to memory.
// Every create, update and delete operation involves both
// in-memory and repository data. Which data is processed first
// depends on the logic.
