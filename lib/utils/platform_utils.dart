import 'package:flutter/foundation.dart';

/// Platform detection utility
class PlatformUtils {
  static bool get isWeb => kIsWeb;
  static bool get isMobile => !kIsWeb;

  /// Check if we should use heavy animations
  static bool get shouldUseHeavyAnimations => !kIsWeb;

  /// Check if we should use shimmer effects
  static bool get shouldUseShimmer => !kIsWeb;

  /// Get animation duration based on platform
  static Duration getAnimationDuration(Duration defaultDuration) {
    return kIsWeb
        ? Duration(milliseconds: (defaultDuration.inMilliseconds * 0.5).round())
        : defaultDuration;
  }
}
