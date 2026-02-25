import 'package:flutter/material.dart';

/// Gradient utility class for consistent gradient backgrounds across all pages
class GradientUtils {
  // Define the 4-color gradient palette
  static const Color topColor = Color(0xFFFCF9EA); // Light cream/beige - Top
  static const Color mediumTopColor = Color(0xFFBADFDB); // Light mint - Top to medium half
  static const Color mediumBottomColor = Color(0xFFFFA4A4); // Pink - Medium half to bottom top
  static const Color bottomColor = Color(0xFFFFBDBD); // Light pink - Bottom top to bottom

  /// Creates a beautiful 4-color gradient decoration
  static BoxDecoration get gradientDecoration => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            topColor,
            mediumTopColor,
            mediumBottomColor,
            bottomColor,
          ],
          stops: const [0.0, 0.33, 0.66, 1.0],
        ),
      );

  /// Creates a gradient widget that can be used as a background
  static Widget gradientBackground({required Widget child}) {
    return Container(
      decoration: gradientDecoration,
      child: child,
    );
  }

  /// Returns the gradient colors as a list
  static List<Color> get gradientColors => [
        topColor,
        mediumTopColor,
        mediumBottomColor,
        bottomColor,
      ];

  /// Returns the gradient stops
  static List<double> get gradientStops => [0.0, 0.33, 0.66, 1.0];
}

