import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
// import '../utils/constants.dart'; // Assume AppDesign constants are available

class StatsCard extends StatelessWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the color scheme for a clean look
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color successColor = Colors.green.shade500;
    final Color warningColor = Colors.orange.shade600;

    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        // Use a Column of three individual, visually distinct tiles instead of a single Row in a Card.
        // The outer Card from the original layout is implicitly handled by the layout
        // in TodoListScreen (now part of the SliverAppBar).
        return Container(
          // Use a custom rounded container or rely on the parent layout if it's a Card
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface, // Use surface color
            borderRadius: BorderRadius.circular(12.0), // AppDesign.radiusMedium
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Total Tasks
              Expanded(
                child: _buildStatItem(
                  context,
                  label: 'Total Tasks',
                  count: todoProvider.totalCount,
                  color: primaryColor,
                  icon: Icons.checklist_rounded,
                ),
              ),
              // Separator for visual cleaness
              const VerticalDivider(
                width: 1,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),

              // 2. Completed Tasks
              Expanded(
                child: _buildStatItem(
                  context,
                  label: 'Completed',
                  count: todoProvider.completedCount,
                  color: successColor,
                  icon: Icons.check_circle_outline_rounded,
                ),
              ),
              // Separator
              const VerticalDivider(
                width: 1,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),

              // 3. Pending Tasks
              Expanded(
                child: _buildStatItem(
                  context,
                  label: 'Pending',
                  count: todoProvider.pendingCount,
                  color: warningColor,
                  icon: Icons.pending_actions_rounded,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Revised _buildStatItem for a modern, high-contrast look
  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Icon and Count in a prominent row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900, // Extra bold count
                  color: color,
                ),
              ),
            ],
          ),

          // 2. Label below
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(
                0.6,
              ), // Muted for hierarchy
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
