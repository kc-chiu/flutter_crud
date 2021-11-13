import 'firebase_todos_repository.dart';
import 'http_todos_repository.dart';
import 'sqflite_todos_repository.dart';
import 'todo.dart';

abstract class TodosRepository {
  // Use a repository implementation by commenting out the other two.

  // factory TodosRepository() => FirebaseTodosRepository();
  factory TodosRepository() => HttpTodosRepository();
  // factory TodosRepository() => SqfliteTodosRepository();

  // Methods to be implemented in repository implementation.
  Future<List<Todo>> readAllTodos(int userId);
  Future<Todo> create(Todo todo, int userId);
  Future<void> update(Todo todo);
  Future<void> delete(Todo todo);
}
