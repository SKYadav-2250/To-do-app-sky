import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        image: DecorationImage(
          image: const AssetImage('assets/images/noise.png'), // Placeholder if noise is wanted later
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.02),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Stack(
        children: [
          // Background blobs for futuristic feel
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? AppColors.primaryDark : AppColors.primaryLight).withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? Colors.purpleAccent : Colors.tealAccent).withOpacity(0.1),
              ),
            ),
          ),
          // Blur effect
          Positioned.fill(
            child: child,
          ),
        ],
      ),
    );
  }
}
