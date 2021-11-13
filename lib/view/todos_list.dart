import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

/// List view of todos.
class TodosList extends StatelessWidget {
  const TodosList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final futureTodos = context.watch<AppState>().futureTodos;
    final appState = context.read<AppState>();

    /// Shows a dialog for user to edit the title of [Todo].
    ///
    /// Returns true if user has edited, false otherwise.
    Future<bool> editTitle(Todo todo) async {
      final controller = TextEditingController(text: todo.title);
      final hasEdited = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Edit Todo Title'),
              content: TextField(
                controller: controller,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(
                      context,
                      controller.text != todo.title &&
                          controller.text.isNotEmpty),
                  child: const Text('Save'),
                ),
              ],
            ),
          ) ??
          false; // In case the user taps outside the dialog.
      if (hasEdited) {
        todo.title = controller.text;
      }
      controller.dispose();
      return hasEdited;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos List'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.filter_list),
            itemBuilder: (context) => [
              PopupMenuItem(
                  onTap: () => appState.todosFilter = TodosFilter.showAll,
                  child: const Text('Show All')),
              PopupMenuItem(
                  onTap: () => appState.todosFilter = TodosFilter.showActive,
                  child: const Text('Show Active')),
              PopupMenuItem(
                  onTap: () => appState.todosFilter = TodosFilter.showCompleted,
                  child: const Text('Show Completed')),
            ],
          ),
          IconButton(
            onPressed: () async {
              final canDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete completed Todos?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete!'),
                    ),
                  ],
                ),
              );
              if (canDelete ?? false) {
                appState.deleteCompletedTodos();
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: FutureBuilder<List<Todo>>(
        future: futureTodos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final todos = snapshot.data;
            return Stack(
              children: [
                ListView.builder(
                  itemCount: todos!.length,
                  itemBuilder: (context, i) {
                    final todo = todos[i];
                    return InkWell(
                      // Shows a dialog for editing the item.
                      onTap: () async {
                        final hasEdited = await editTitle(todo);
                        if (hasEdited) {
                          await appState.update(todo);
                        }
                      },
                      child: ListTile(
                        title: Text(todo.title),
                        trailing: Checkbox(
                          value: todo.isCompleted,
                          onChanged: (_) {
                            appState.toggleCompletion(todo);
                          },
                        ),
                      ),
                    );
                  },
                ),
                // Progress indicator for [Todo] deletion.
                context.watch<AppState>().inProgress
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink(),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              '${snapshot.error}',
              style: const TextStyle(fontSize: 18),
            ));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Shows a dialog for editing the title of a new [toto].
        onPressed: () async {
          final todo = Todo('', '', false);
          final hasEdited = await editTitle(todo);
          if (hasEdited) {
            await appState.create(todo);
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Create Todo',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
