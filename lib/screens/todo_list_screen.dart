import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../providers/theme_provider.dart';
import '../models/todo_item.dart';
// Note: You will need to import AuthProvider and handle logout if you want the logout button
// import '../providers/auth_provider.dart';
import '../widgets/stats_card.dart';
import '../widgets/todo_item_card.dart';
import '../widgets/empty_state.dart';

// Enum for the sleek Segmented Control
enum TodoFilter { all, pending, completed }

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  TodoFilter _filter = TodoFilter.pending; // Default to pending tasks

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTodoItem() {
    final text = _textEditingController.text.trim();
    if (text.isEmpty) return;

    Provider.of<TodoProvider>(context, listen: false).addTodo(text);
    _textEditingController.clear();
    // Keep focus on mobile/tablet after adding for rapid task entry
    // _focusNode.unfocus();
  }

  // Helper method to get the list based on the current filter
  List<TodoItem> _getFilteredList(TodoProvider todoProvider) {
    switch (_filter) {
      case TodoFilter.all:
        return todoProvider.allTodos;
      case TodoFilter.pending:
        return todoProvider.pendingTodos;
      case TodoFilter.completed:
        return todoProvider.completedTodos;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;

    // Determine the size of the bottom input (approx 90-100 pixels)
    const double bottomInputHeight = 100.0;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text(
                'Pro Task Manager',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              backgroundColor: colorScheme.background, // Match app background

              actions: [
                // FIX 2: Theme Toggle visibility (Use colorScheme.onSurface for contrast)
                IconButton(
                  icon: Icon(
                    themeProvider.themeMode == ThemeMode.dark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    color: colorScheme
                        .onSurface, // Ensures visibility in both themes
                  ),
                  onPressed: () => themeProvider.toggleTheme(
                    themeProvider.themeMode != ThemeMode.dark,
                  ),
                ),
                // Optional: Add Logout Button here for complete UI
                // IconButton(
                //   icon: Icon(Icons.logout_rounded, color: colorScheme.onSurface.withOpacity(0.7)),
                //   onPressed: () { /* AuthProvider.logout() logic */ },
                // ),
                const SizedBox(width: 8),
              ],

              // FIX 1: Increased height to fix the bottom overflow
              bottom: PreferredSize(
                // Increased from 140.0 to 180.0 for safety and consistent spacing
                preferredSize: const Size.fromHeight(180.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0, // Retained vertical padding
                  ),
                  child: Column(
                    children: [
                      const StatsCard(),
                      const SizedBox(
                        height: 12,
                      ), // Slightly adjusted vertical spacer
                      _buildFilterSegment(context),
                      const SizedBox(
                        height: 4,
                      ), // Add small gap below the filter
                    ],
                  ),
                ),
              ),
            ),
          ];
        },

        body: Consumer<TodoProvider>(
          builder: (context, todoProvider, child) {
            final filteredList = _getFilteredList(todoProvider);

            if (filteredList.isEmpty) {
              // FIX 3: Add padding to EmptyState equal to bottom input height
              // to prevent it from being obscured.
              return Padding(
                padding: const EdgeInsets.only(bottom: bottomInputHeight),
                child: EmptyState(
                  message: _filter == TodoFilter.all
                      ? "All tasks complete! Time for a break. ☕"
                      : _filter == TodoFilter.pending
                      ? "No pending tasks. Great job!"
                      : "No completed tasks yet.",
                ),
              );
            }

            // List View padding now uses the bottom input height for safe area
            return ListView.separated(
              padding: const EdgeInsets.only(
                top: 10,
                bottom:
                    bottomInputHeight, // Use bottomInputHeight for safe scrolling
                left: 16,
                right: 16,
              ),
              itemCount: filteredList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return TodoItemCard(todoItem: item);
              },
            );
          },
        ),
      ),

      // Impressive UI Change: Sticky Bottom Input
      bottomSheet: _buildBottomInput(context),
    );
  }

  // Custom Widget for the Sleek Segmented Control (No changes here)
  Widget _buildFilterSegment(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: TodoFilter.values.map((filter) {
            final isSelected = _filter == filter;
            String text;
            int count;

            switch (filter) {
              case TodoFilter.all:
                text = 'All';
                count = todoProvider.totalCount;
                break;
              case TodoFilter.pending:
                text = 'Pending';
                count = todoProvider.pendingCount;
                break;
              case TodoFilter.completed:
                text = 'Done';
                count = todoProvider.completedCount;
                break;
            }

            return Expanded(
              child: InkWell(
                onTap: () => setState(() => _filter = filter),
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.4),
                              blurRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$text ($count)',
                    style: TextStyle(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Custom Widget for the Sticky Bottom Input (No changes here)
  Widget _buildBottomInput(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        10 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: TextField(
          controller: _textEditingController,
          focusNode: _focusNode,
          onSubmitted: (_) => _addTodoItem(),
          decoration: InputDecoration(
            hintText: 'Add a new task...',
            filled: true,
            fillColor: colorScheme.surfaceVariant.withOpacity(0.4),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(Icons.add_circle_rounded, size: 30),
                color: colorScheme.primary,
                onPressed: _addTodoItem,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
