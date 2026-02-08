import 'package:flutter/material.dart';
import 'package:pet_haven/theme/color.dart';

/// A fun and engaging dialog shown when battery drops below 20%.
///
/// This dialog displays a humorous message to encourage users
/// to charge their device while acknowledging their love for the app.
class LowBatteryDialog extends StatelessWidget {
  final int batteryLevel;
  final VoidCallback onDismiss;

  const LowBatteryDialog({
    super.key,
    required this.batteryLevel,
    required this.onDismiss,
  });

  /// Shows the low battery dialog
  static Future<void> show(
    BuildContext context,
    int batteryLevel,
    VoidCallback onDismiss,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          LowBatteryDialog(batteryLevel: batteryLevel, onDismiss: onDismiss),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 16,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isDark ? AppColors.darkMode : colorScheme.surface,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated battery icon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.battery_alert_rounded,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    Positioned(
                      bottom: 8,
                      child: Text(
                        '$batteryLevel%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Funny title
            Text(
              'Woah There, Pet Lover!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Funny message
            Text(
              'We know you\'re absolutely OBSESSED with our adorable pet products (who wouldn\'t be?), but your phone is running on fumes!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Call to action
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bolt, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Plug in, recharge, and come back for more pawsome deals!',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Dismiss button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onDismiss();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Got it!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Secondary dismiss option
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDismiss();
              },
              child: Text(
                'Continue browsing anyway',
                style: TextStyle(
                  color: isDark ? Colors.white60 : colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
