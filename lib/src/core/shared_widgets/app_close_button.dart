import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../resourses/color_manager/app_colors.dart';

class AppCloseButton extends StatelessWidget {
  const AppCloseButton(
      {super.key,
      this.icon,
      this.width,
      this.height,
      this.backgroundColor = AppColors.white,
      this.iconColor = AppColors.primary});
  final Widget? icon;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.16),
            blurRadius: 4.0,
            offset: const Offset(0.0, 1.0),
          ),
        ],
      ),
      child: IconButton(
        onPressed: context.pop,
        style: IconButton.styleFrom(foregroundColor: iconColor),
        icon: icon ?? Icon(Icons.close, color: iconColor),
      ),
    );
  }
}
