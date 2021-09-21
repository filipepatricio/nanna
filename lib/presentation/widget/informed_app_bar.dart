import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class InformedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool showSettingsIcon;
  final bool isTriangleShape;

  const InformedAppBar({
    required this.title,
    this.showSettingsIcon = false,
    this.isTriangleShape = false,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(AppDimens.appBarSize);

  @override
  _InformedAppBarState createState() => _InformedAppBarState(title, showSettingsIcon, isTriangleShape);
}

class _InformedAppBarState extends State<InformedAppBar> {
  final String title;
  final bool showSettingsIcon;
  final bool isTriangleShape;

  _InformedAppBarState(this.title, this.showSettingsIcon, this.isTriangleShape);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: AppDimens.zero, color: AppColors.appBarBackground),
                color: AppColors.appBarBackground,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.sl),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: AppTypography.h1Bold.copyWith(color: AppColors.white)),
                      if (showSettingsIcon)
                        GestureDetector(
                          onTap: () => AutoRouter.of(context).push(const SettingsMainPageRoute()),
                          child: SvgPicture.asset(
                            AppVectorGraphics.settings,
                            width: AppDimens.l,
                            height: AppDimens.l,
                            fit: BoxFit.contain,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CustomPaint(
            painter: ShadowPainter(isTriangleShaped: isTriangleShape),
            child: ClipPath(
              clipper: isTriangleShape ? const TriangleClipper() : const DiagonalClipper(),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: AppDimens.zero, color: AppColors.appBarBackground),
                  color: AppColors.appBarBackground,
                ),
                height: AppDimens.m,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  const TriangleClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => true;
}

class DiagonalClipper extends CustomClipper<Path> {
  const DiagonalClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(DiagonalClipper oldClipper) => false;
}

class ShadowPainter extends CustomPainter {
  final bool isTriangleShaped;

  ShadowPainter({required this.isTriangleShaped});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (isTriangleShaped) {
      path.lineTo(size.width, 0.0);
      path.lineTo(size.width / 2, size.height);
    } else {
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
    }
    path.close();

    canvas.drawShadow(path, Colors.black87, 2.0, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
