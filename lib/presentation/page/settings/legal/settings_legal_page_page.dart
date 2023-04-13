import 'package:better_informed_mobile/domain/legal_page/data/legal_page_type.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/legal/settings_legal_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/legal/settings_legal_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/error_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_app_bar/informed_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsLegalPagePage extends HookWidget {
  const SettingsLegalPagePage({required this.type});

  final LegalPageType type;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SettingsLegalPageCubit>();
    final state = useCubitBuilder<SettingsLegalPageCubit, SettingsLegalPageState>(cubit);

    useEffect(
      () {
        cubit.initialize(type);
      },
      [cubit],
    );

    return Scaffold(
      appBar: InformedAppBar(
        isConnected: context.watch<IsConnected>(),
        leading: BackTextButton(
          text: context.l10n.settings_settings,
        ),
        title: state.when(
          idle: (page) => page.title,
          loading: () => null,
          error: () => null,
        ),
      ),
      body: state.when(
        idle: (page) => ListView(
          physics: getPlatformScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimens.m),
                  InformedMarkdownBody(
                    markdown: page.content,
                    baseTextStyle: AppTypography.articleText.copyWith(
                      height: 1.5,
                    ),
                    pPadding: const EdgeInsets.only(top: AppDimens.m),
                  ),
                  const SizedBox(height: AppDimens.xxl),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Loader(),
        error: () => Center(
          child: ErrorView(
            retryCallback: () => cubit.initialize(type),
          ),
        ),
      ),
    );
  }
}
