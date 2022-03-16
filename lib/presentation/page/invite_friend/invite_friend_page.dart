import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InviteFriendPage extends StatelessWidget {
  const InviteFriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        title: Text(
          tr(LocaleKeys.inviteFriend_title),
          style: AppTypography.b1Bold,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: SvgPicture.asset(AppVectorGraphics.bigGift),
              ),
              const SizedBox(height: AppDimens.m),
              Text(
                tr(LocaleKeys.inviteFriend_header),
                textAlign: TextAlign.center,
                style: AppTypography.h2Jakarta,
              ),
              const SizedBox(height: AppDimens.s),
              Text(
                tr(
                  LocaleKeys.inviteFriend_content,
                  args: [
                    '3',
                  ],
                ),
                textAlign: TextAlign.center,
                style: AppTypography.h4Normal,
              ),
              const SizedBox(height: AppDimens.xxl),
              DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(AppDimens.s),
                color: AppColors.textPrimary,
                strokeWidth: 1.5,
                strokeCap: StrokeCap.round,
                dashPattern: const [0.2, 6],
                padding: EdgeInsets.zero,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.m,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppDimens.s),
                    ),
                    color: AppColors.pastelGreen,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'YDG3T5',
                        style: AppTypography.b1Bold.copyWith(height: 1.5),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(AppVectorGraphics.copy),
                        padding: EdgeInsets.zero,
                        splashRadius: AppDimens.l,
                      ),
                      Text(
                        tr(LocaleKeys.common_copy),
                        style: AppTypography.b3Regular.copyWith(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.m),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.textPrimary,
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      AppDimens.s,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.m,
                  vertical: AppDimens.sl,
                ),
                child: Center(
                  child: Text(
                    tr(LocaleKeys.inviteFriend_inviteAction),
                    style: AppTypography.h4Bold,
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.xxl),
              Text(
                tr(
                  LocaleKeys.inviteFriend_usage,
                  args: [
                    '2',
                    '3',
                  ],
                ),
                textAlign: TextAlign.center,
                style: AppTypography.h4Normal.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
