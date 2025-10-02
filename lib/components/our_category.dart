import 'package:flutter/material.dart';

/// A category widget that displays a circular image and a title below it,
/// with a subtle scaling animation when tapped.
///
/// The [OurCategory] widget is useful for category selectors or menus
/// in apps (e.g., Pet Food, Toys, Grooming).
///
/// Features:
/// - Circular avatar image loaded from [imagePath].
/// - Title displayed below the image.
/// - Interactive scaling effect on tap (press shrinks, release restores).
/// - Optional [onTap] callback for handling tap actions.
class OurCategory extends StatefulWidget {
  /// The text label displayed below the circular image.
  final String title;

  /// The asset path of the image to display inside the circle.
  final String imagePath;

  /// A callback that is triggered when the user taps the widget.
  ///
  /// If null, tapping the widget only plays the animation without
  /// performing any additional action.
  final VoidCallback? onTap;

  /// Creates an [OurCategory] widget.
  ///
  /// The [imagePath] and [title] are required.
  const OurCategory({
    super.key,
    required this.imagePath,
    required this.title,
    this.onTap,
  });

  @override
  State<OurCategory> createState() => _OurCategoryState();
}

/// The state class for [OurCategory], responsible for handling
/// the tap animation (scaling effect).
class _OurCategoryState extends State<OurCategory> {
  /// The current scale factor of the widget.
  ///
  /// Defaults to `1.0` (normal size). Temporarily reduces to `0.9`
  /// when pressed, then animates back to `1.0` on release or cancel.
  double _scale = 1.0;

  /// Called when the user presses down on the widget.
  void _onTapDown(TapDownDetails d) => setState(() => _scale = 0.9);

  /// Called when the user lifts their finger after tapping.
  void _onTapUp(TapUpDetails d) => setState(() => _scale = 1.0);

  /// Called when the tap gesture is cancelled.
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: widget.onTap,
          child: AnimatedScale(
            /// Smoothly animates between pressed (0.9) and normal (1.0) sizes.
            scale: _scale,
            duration: const Duration(milliseconds: 150),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(widget.imagePath),
            ),
          ),
        ),
        const SizedBox(height: 8),

        /// Displays the category title below the image.
        Text(widget.title),
      ],
    );
  }
}
