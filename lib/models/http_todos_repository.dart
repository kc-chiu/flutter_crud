import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models.dart';

class HttpTodosRepository implements TodosRepository {
  // The url only gives fake HTTP responses.
  // The data on the server will not be actually updated.
  // e.g. Although the API returns a success response for http.delete
  // request, you can immediately http.get the same data again.
  final url = 'https://jsonplaceholder.typicode.com/todos';

  @override
  Future<List<Todo>> readAllTodos(int userId) async {
    final response = await http.get(Uri.parse('$url?userId=$userId'));
    if (response.statusCode == 200) {
      final jsons = jsonDecode(response.body);
      final todos = <Todo>[];
      for (final json in jsons) {
        // Handles the difference in field name between
        // model and data provider.
        json['isCompleted'] = json['completed'];
        todos.add(Todo.fromJson(json));
      }
      return todos;
    } else {
      throw Exception('Failed to read data: ${response.statusCode}');
    }
  }

  @override
  // When creating a new record,
  // do not provide record id in the post body.
  // New record id should be generated by the server and
  // be available in the response body.
  // As this is only a fake response, ALL new records get
  // the same new id!
  Future<Todo> create(Todo todo, int userId) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': todo.title,
        'userid': userId,
        'completed': false,
      }),
    );
    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      json['isCompleted'] = json['completed'];
      return Todo.fromJson(json);
    } else {
      throw Exception('Failed to create Todo: ${response.statusCode}');
    }
  }

  @override
  Future<void> update(Todo todo) async {
    final response = await http.patch(
      Uri.parse('$url/${todo.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': todo.title,
        'completed': todo.isCompleted,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update Todo: ${response.statusCode}');
    }
  }

  @override
  Future<void> delete(Todo todo) async {
    final response = await http.delete(
      Uri.parse('$url/${todo.id}'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete Todo: ${response.statusCode}');
    }
  }
}
