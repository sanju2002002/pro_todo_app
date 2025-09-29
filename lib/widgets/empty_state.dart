import 'package:flutter/material.dart';
// Import your design constants for consistent spacing
// import '../utils/constants.dart';

class EmptyState extends StatelessWidget {
  // Added required message for flexibility (e.g., "No Pending Tasks")
  final String message;

  // Optional: A specific icon for different empty states (e.g., a trophy for completed)
  final IconData? icon;

  const EmptyState({super.key, required this.message, this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Keep column size minimal
          children: [
            // 1. The Impressive Visual Element (Mimicking an Illustration)
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Use a soft, subtle radial gradient for depth
                gradient: RadialGradient(
                  colors: [
                    colorScheme.primary.withOpacity(0.1),
                    colorScheme.background,
                  ],
                  stops: const [0.0, 1.0],
                  center: Alignment.center,
                  radius: 0.8,
                ),
              ),
              child: Icon(
                icon ?? Icons.folder_open_rounded, // Use a modern, filled icon
                size: 80,
                color: colorScheme.primary.withOpacity(
                  0.7,
                ), // Subtle primary color
              ),
            ),

            // A visual break
            const SizedBox(height: 32),

            // 2. Engaging Title/Message
            Text(
              'Nothing to see here!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface.withOpacity(
                  0.85,
                ), // Darker for emphasis
              ),
            ),

            // Smaller visual break
            const SizedBox(height: 8),

            // 3. Informative/Guidance Text
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(
                  0.6,
                ), // Muted for secondary text
                height: 1.5,
              ),
            ),

            // 4. Optional Call to Action Hint (New)
            const SizedBox(height: 24),
            Text(
              'Tap the "Add" field below to start.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
