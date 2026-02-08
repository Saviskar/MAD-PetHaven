import 'package:flutter/material.dart';

/// A banner widget that displays when the app is in offline mode.
///
/// Shows a subtle indicator at the top of the screen to inform users
/// that they are viewing cached data and may not have the latest updates.
class OfflineBanner extends StatelessWidget {
  final String? cacheAge;

  const OfflineBanner({super.key, this.cacheAge});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.orange.shade900.withValues(alpha: 0.9)
            : Colors.orange.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 20,
              color: isDark ? Colors.orange.shade200 : Colors.orange.shade800,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'You\'re offline',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.orange.shade900,
                    ),
                  ),
                  Text(
                    cacheAge != null
                        ? 'Showing cached data from $cacheAge'
                        : 'Showing cached data',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white70 : Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? Colors.orange.shade800 : Colors.orange.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: 14,
                    color: isDark ? Colors.white70 : Colors.orange.shade800,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Offline',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.orange.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
