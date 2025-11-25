import 'package:flutter_vibrate/flutter_vibrate.dart';

/// Haptic feedback utility for better UX
class HapticFeedbackUtil {
  static Future<void> light() async {
    try {
      final canVibrate = await Vibrate.canVibrate;
      if (canVibrate) {
        Vibrate.feedback(FeedbackType.light);
      }
    } catch (e) {
      // Haptic feedback not available on this device
    }
  }

  static Future<void> medium() async {
    try {
      final canVibrate = await Vibrate.canVibrate;
      if (canVibrate) {
        Vibrate.feedback(FeedbackType.medium);
      }
    } catch (e) {
      // Haptic feedback not available
    }
  }

  static Future<void> heavy() async {
    try {
      final canVibrate = await Vibrate.canVibrate;
      if (canVibrate) {
        Vibrate.feedback(FeedbackType.heavy);
      }
    } catch (e) {
      // Haptic feedback not available
    }
  }

  static Future<void> selection() async {
    try {
      final canVibrate = await Vibrate.canVibrate;
      if (canVibrate) {
        Vibrate.feedback(FeedbackType.selection);
      }
    } catch (e) {
      // Haptic feedback not available
    }
  }

  static Future<void> success() async {
    try {
      final canVibrate = await Vibrate.canVibrate;
      if (canVibrate) {
        Vibrate.feedback(FeedbackType.success);
      }
    } catch (e) {
      // Haptic feedback not available
    }
  }

  static Future<void> warning() async {
    try {
      final canVibrate = await Vibrate.canVibrate;
      if (canVibrate) {
        Vibrate.feedback(FeedbackType.warning);
      }
    } catch (e) {
      // Haptic feedback not available
    }
  }

  static Future<void> error() async {
    try {
      final canVibrate = await Vibrate.canVibrate;
      if (canVibrate) {
        Vibrate.feedback(FeedbackType.error);
      }
    } catch (e) {
      // Haptic feedback not available
    }
  }
}

/// Animated button with haptic feedback
class HapticButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final FeedbackType feedbackType;

  const HapticButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.feedbackType = FeedbackType.light,
  }) : super(key: key);

  @override
  State<HapticButton> createState() => _HapticButtonState();
}

class _HapticButtonState extends State<HapticButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward();
    await _controller.reverse();

    // Trigger haptic feedback
    try {
      final canVibrate = await Vibrate.canVibrate;
      if (canVibrate) {
        Vibrate.feedback(widget.feedbackType);
      }
    } catch (e) {
      // Haptic not available
    }

    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
