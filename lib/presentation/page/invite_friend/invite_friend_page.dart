import 'package:better_informed_mobile/domain/invite/data/invite_code.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/invite_friend/invite_friend_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/invite_friend/invite_friend_page_state.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class InviteFriendPage extends HookWidget {
  const InviteFriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<InviteFriendPageCubit>();
    final state = useCubitBuilder(cubit);
    final snackbarController = useMemoized(() => SnackbarController());

    useCubitListener<InviteFriendPageCubit, InviteFriendPageState>(
      cubit,
      (cubit, state, context) {
        state.mapOrNull(
          codeCopied: (_) {
            snackbarController.showMessage(
              SnackbarMessage.simple(
                message: tr(LocaleKeys.inviteFriend_codeCopied),
                type: SnackbarMessageType.positive,
              ),
            );
          },
        );
      },
    );

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        title: Text(
          tr(LocaleKeys.inviteFriend_title),
          style: AppTypography.b2Bold,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SnackbarParentView(
        controller: snackbarController,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: state.mapOrNull(
              loading: (_) => const Loader(
                color: AppColors.limeGreen,
              ),
              idle: (state) => _Idle(
                inviteCode: state.code,
                cubit: cubit,
              ),
              error: (state) => GeneralErrorView(
                title: tr(LocaleKeys.common_error_oops),
                content: tr(LocaleKeys.common_generalError),
                svgPath: AppVectorGraphics.magError,
                retryCallback: () => cubit.initialize(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Idle extends StatelessWidget {
  const _Idle({
    required this.inviteCode,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final InviteCode inviteCode;
  final InviteFriendPageCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              inviteCode.maxUseCount.toString(),
            ],
          ),
          textAlign: TextAlign.center,
          style: AppTypography.h4Normal,
        ),
        const SizedBox(height: AppDimens.xxl),
        _CodeContainer(
          cubit: cubit,
          inviteCode: inviteCode,
        ),
        const SizedBox(height: AppDimens.m),
        GestureDetector(
          onTap: () => cubit.shareCode(),
          child: Container(
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
        ),
        const SizedBox(height: AppDimens.xxl),
        Text(
          tr(
            LocaleKeys.inviteFriend_usage,
            args: [
              inviteCode.useCount.toString(),
              inviteCode.maxUseCount.toString(),
            ],
          ),
          textAlign: TextAlign.center,
          style: AppTypography.h4Normal.copyWith(
            color: AppColors.textGrey,
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}

class _CodeContainer extends StatelessWidget {
  const _CodeContainer({
    required this.inviteCode,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final InviteCode inviteCode;
  final InviteFriendPageCubit cubit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => cubit.copyCode(),
      child: DottedBorder(
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
            vertical: AppDimens.sl,
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
                inviteCode.code,
                style: AppTypography.b2Bold.copyWith(height: 1.5),
              ),
              const Spacer(),
              SvgPicture.asset(AppVectorGraphics.copy),
              const SizedBox(width: AppDimens.s),
              Text(
                tr(LocaleKeys.common_copy),
                style: AppTypography.b3Regular.copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
