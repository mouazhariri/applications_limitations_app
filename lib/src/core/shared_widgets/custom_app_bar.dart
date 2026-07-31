import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:applications_limitations/gen/assets.gen.dart';
import 'package:applications_limitations/src/application/router/app_routes.dart';
import 'package:applications_limitations/src/core/utils/extenssions/int_extenssion.dart';
import 'package:applications_limitations/src/resourses/color_manager/app_colors.dart';
import 'package:applications_limitations/src/resourses/font_manager/app_text_style.dart';

class CustomDeafultAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool? withBackButton;
  final Widget? actionButton;
  const CustomDeafultAppbar({
    super.key,
    required this.title,
    this.withBackButton = true,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Container(
      height: preferredSize.height + topPadding,
      padding: EdgeInsets.symmetric(horizontal: 22),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (withBackButton ?? false)
                ? IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textHeading,
                    ))
                : 22.horizontalSpace,
            Center(
              child: Text(
                title,
                style: AppTextStyle.rubikBold20.copyWith(
                  color: AppColors.textHeading,
                ),
              ),
            ),
            (actionButton != null) ? actionButton! : 22.horizontalSpace,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
