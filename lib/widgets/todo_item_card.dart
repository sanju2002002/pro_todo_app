import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_item.dart';
import '../providers/todo_provider.dart';
// import '../utils/constants.dart'; // Assuming AppDesign is available

class TodoItemCard extends StatelessWidget {
  final TodoItem todoItem;

  const TodoItemCard({super.key, required this.todoItem});

  String _formatTime(BuildContext context, DateTime time) {
    return TimeOfDay.fromDateTime(time).format(context);
  }

  // New: Method to show a delete confirmation dialog
  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    TodoProvider todoProvider,
  ) async {
    final colorScheme = Theme.of(context).colorScheme;
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete Task?',
            style: TextStyle(
              color: colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${todoItem.text}"?',
            style: TextStyle(color: colorScheme.onSurface.withOpacity(0.8)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      todoProvider.deleteTodo(todoItem.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task "${todoItem.text}" deleted.'),
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;

    final Color primaryColor = colorScheme.primary;
    final Color successColor = Colors.green.shade500;
    final Color pendingColor = colorScheme.onSurface.withOpacity(0.8);
    final Color completedTextColor = colorScheme.onSurface.withOpacity(0.4);
    final Color cardBackgroundColor = todoItem.isCompleted
        ? colorScheme.surfaceVariant.withOpacity(0.3)
        : colorScheme.surface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Dismissible(
        key: ValueKey(todoItem.id),
        direction: DismissDirection.horizontal,

        // Background for swipe right (complete/undo)
        background: _buildSwipeAction(
          context,
          alignment: Alignment.centerLeft,
          color: successColor,
          icon: Icons.check_circle_outline_rounded,
          label: todoItem.isCompleted ? 'Undo' : 'Complete', // Dynamic label
        ),

        // Secondary Background for swipe left (delete)
        secondaryBackground: _buildSwipeAction(
          context,
          alignment: Alignment.centerRight,
          color: Colors.red.shade600,
          icon: Icons.delete_sweep_rounded,
          label: 'Delete',
        ),

        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            // Swipe Left (Delete)
            // Show dialog for confirmation when swiping left
            return await showDialog<bool>(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        'Delete Task?',
                        style: TextStyle(
                          color: colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to delete "${todoItem.text}"?',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: colorScheme.onSurface),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.error,
                            foregroundColor: colorScheme.onError,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                ) ??
                false; // Return false if dialog is dismissed without selection
          } else if (direction == DismissDirection.startToEnd) {
            // Swipe Right (Complete/Undo)
            todoProvider.toggleTodoStatus(todoItem.id);
            // Show a snackbar feedback for status change
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  todoItem.isCompleted
                      ? 'Task marked as pending!'
                      : 'Task "${todoItem.text}" completed!',
                ),
                backgroundColor: todoItem.isCompleted
                    ? primaryColor
                    : successColor,
                duration: const Duration(seconds: 2),
              ),
            );
            return false; // Prevent full dismissal, just update status
          }
          return false;
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: colorScheme.onSurface.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border(
              left: BorderSide(
                color: todoItem.isCompleted ? successColor : primaryColor,
                width: 6,
              ),
            ),
          ),

          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),

            leading: InkWell(
              onTap: () => todoProvider.toggleTodoStatus(todoItem.id),
              customBorder:
                  const CircleBorder(), // Make InkWell ripple circular
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: todoItem.isCompleted
                        ? successColor
                        : primaryColor.withOpacity(0.7),
                    width: todoItem.isCompleted ? 0 : 2,
                  ),
                  color: todoItem.isCompleted
                      ? successColor
                      : Colors.transparent,
                ),
                child: todoItem.isCompleted
                    ? const Icon(Icons.check, size: 20, color: Colors.white)
                    : null,
              ),
            ),

            title: Text(
              todoItem.text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                decoration: todoItem.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: todoItem.isCompleted ? completedTextColor : pendingColor,
              ),
            ),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Added ${_formatTime(context, todoItem.createdAt)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                if (todoItem.isCompleted && todoItem.completedAt != null)
                  Text(
                    'Completed ${_formatTime(context, todoItem.completedAt!)}',
                    style: TextStyle(
                      fontSize: 11, // Slightly smaller for completion time
                      color: successColor.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),

            // New Trailing Widget: More options (for delete, edit, etc.)
            trailing: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteConfirmationDialog(context, todoProvider);
                }
                // Add more actions here (e.g., 'edit')
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Delete Task',
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ],
                  ),
                ),
                // PopupMenuItem<String>(
                //   value: 'edit',
                //   child: Row(
                //     children: [
                //       Icon(Icons.edit_rounded, color: colorScheme.onSurface),
                //       const SizedBox(width: 8),
                //       Text('Edit Task', style: TextStyle(color: colorScheme.onSurface)),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for the swipe background (now with label)
  Widget _buildSwipeAction(
    BuildContext context, {
    required Alignment alignment,
    required Color color,
    required IconData icon,
    required String label, // Added label
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
