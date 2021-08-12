import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppError extends StatefulWidget {
  final String? message;
  final String? graphicPath;

  const AppError({Key? key, this.message, this.graphicPath}) : super(key: key);

  @override
  _AppErrorState createState() => _AppErrorState(message, graphicPath);
}

class _AppErrorState extends State<AppError> {
  final String? message;
  final String? graphicPath;

  _AppErrorState(this.message, this.graphicPath);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              graphicPath ?? AppVectorGraphics.readsExploreError,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: AppDimens.l),
            Text(
              message ?? LocaleKeys.common_generalError.tr(),
              textAlign: TextAlign.center,
              style: AppTypography.systemText,
            ),
          ],
        ),
      ),
    );
  }
}
