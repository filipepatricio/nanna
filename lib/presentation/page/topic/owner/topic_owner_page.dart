import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/common/data/curator.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/topic_owner_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/topic_owner_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/widgets/owner_topics.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/util/padding_tap_widget.dart';
import 'package:better_informed_mobile/presentation/widget/curation/curator_avatar_big.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_animated_switcher.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TopicOwnerPage extends HookWidget {
  const TopicOwnerPage({
    required this.owner,
    this.fromTopicSlug,
    Key? key,
  }) : super(key: key);

  final Curator owner;
  final String? fromTopicSlug;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TopicOwnerPageCubit>();
    final state = useCubitBuilder(cubit);
    final snackbarController = useMemoized(() => SnackbarController());

    useCubitListener<TopicOwnerPageCubit, TopicOwnerPageState>(
      cubit,
      (cubit, state, context) {
        state.mapOrNull(
          browserError: (state) {
            showBrowserError(state.link, snackbarController);
          },
        );
      },
    );

    useEffect(
      () {
        cubit.initialize(owner, fromTopicSlug);
      },
      [owner],
    );

    final scrollController = useMemoized(
      () => ModalScrollController.of(context) ?? ScrollController(keepScrollOffset: true),
    );

    return SnackbarParentView(
      child: SafeArea(
        bottom: false,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimens.m)),
          child: Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionsBar(controller: scrollController, owner: owner),
                Container(
                  color: AppColors.of(context).borderPrimary,
                  height: AppDimens.one,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    physics: getPlatformScrollPhysics(),
                    controller: scrollController,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppDimens.m),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
                            child: CuratorAvatarBig(curator: owner),
                          ),
                          const SizedBox(height: AppDimens.m),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
                            child: Text(
                              owner.bio,
                              softWrap: true,
                              style: AppTypography.articleText,
                            ),
                          ),
                          const SizedBox(height: AppDimens.s),
                          if (owner is! EditorialTeamCurator) ...[
                            InformedAnimatedSwitcher(
                              duration: const Duration(milliseconds: 1000),
                              child: state.maybeMap(
                                idleExpert: (state) => state.topics.isEmpty
                                    ? const SizedBox.shrink()
                                    : OwnerTopics(
                                        topics: state.topics,
                                      ),
                                idleEditor: (state) => state.topics.isEmpty
                                    ? const SizedBox.shrink()
                                    : OwnerTopics(
                                        topics: state.topics,
                                      ),
                                orElse: () => const SizedBox.shrink(),
                              ),
                            ),
                          ],
                          if (owner is! ExpertCurator) ...[
                            const SizedBox(height: AppDimens.m),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
                              child: InformedFilledButton.secondary(
                                context: context,
                                text: LocaleKeys.topic_howWeCurateContent_label.tr(),
                                trailing: const InformedSvg(
                                  AppVectorGraphics.chevronNext,
                                  fit: BoxFit.scaleDown,
                                ),
                                withOutline: true,
                                onTap: () => context.pushRoute(const HowDoWeCurateContentPageRoute()),
                              ),
                            ),
                            const SizedBox(height: AppDimens.s),
                          ],
                          if (owner is ExpertCurator && (owner as ExpertCurator).hasSocialMediaLinks) ...[
                            const SizedBox(height: AppDimens.m),
                            _SocialMediaLinks(
                              cubit: cubit,
                              owner: owner as ExpertCurator,
                            ),
                            const SizedBox(height: AppDimens.c),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionsBar extends HookWidget {
  const _ActionsBar({
    required this.controller,
    required this.owner,
    Key? key,
  }) : super(key: key);

  final Curator owner;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final showOwnerTitle = useState(0.0);
    final actionBarTitle = owner.map(
      editor: (owner) => LocaleKeys.topic_owner_editorTitle.tr(),
      expert: (owner) => LocaleKeys.topic_owner_expertTitle.tr(),
      editorialTeam: (owner) => LocaleKeys.topic_owner_editorialTeamTitle.tr(),
      unknown: (_) => "",
    );

    void setShowOwnerTitle() {
      if (controller.hasClients) {
        final currentOffset = controller.offset;
        const opacityThreshold = kToolbarHeight * 1.5;

        if (currentOffset <= 0 || currentOffset < opacityThreshold) {
          if (showOwnerTitle.value != 0) showOwnerTitle.value = 0;
          return;
        }

        if (showOwnerTitle.value != 1) showOwnerTitle.value = 1;
      }
    }

    useEffect(
      () {
        controller.addListener(setShowOwnerTitle);
        return () => controller.removeListener(setShowOwnerTitle);
      },
      [controller],
    );

    return Container(
      height: kToolbarHeight,
      color: AppColors.of(context).backgroundPrimary,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: AppDimens.pageHorizontalMargin,
            child: Text(
              actionBarTitle,
              style: AppTypography.b2Medium,
            ),
          ),
          Positioned(
            right: AppDimens.pageHorizontalMargin,
            child: PaddingTapWidget(
              onTap: () => context.popRoute(),
              tapPadding: const EdgeInsets.all(AppDimens.m),
              child: const InformedSvg(
                AppVectorGraphics.closeBackground,
                fit: BoxFit.scaleDown,
                colored: false,
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: showOwnerTitle.value,
            duration: const Duration(milliseconds: 200),
            child: Center(
              child: Text(owner.name, style: AppTypography.h4Bold),
            ),
          )
        ],
      ),
    );
  }
}

class _SocialMediaLinks extends StatelessWidget {
  const _SocialMediaLinks({
    required this.cubit,
    required this.owner,
    Key? key,
  }) : super(key: key);

  final TopicOwnerPageCubit cubit;
  final ExpertCurator owner;

  @override
  Widget build(BuildContext context) {
    final instagram = owner.instagram;
    final linkedin = owner.linkedin;
    final website = owner.website;
    final twitter = owner.twitter;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InformedMarkdownBody(
            markdown: LocaleKeys.topic_owner_followExpertOn.tr(args: [owner.name]),
            baseTextStyle: AppTypography.b2Regular.copyWith(height: 2.0),
          ),
          const SizedBox(height: AppDimens.m),
          Row(
            children: [
              if (instagram != null)
                _SocialMediaIcon(
                  icon: AppVectorGraphics.instagram,
                  onTap: () => cubit.openSocialMediaLink(instagram),
                ),
              if (twitter != null)
                _SocialMediaIcon(
                  icon: AppVectorGraphics.twitter,
                  onTap: () => cubit.openSocialMediaLink(twitter),
                ),
              if (linkedin != null)
                _SocialMediaIcon(
                  icon: AppVectorGraphics.linkedin,
                  onTap: () => cubit.openSocialMediaLink(linkedin),
                ),
              if (website != null)
                _SocialMediaIcon(
                  icon: AppVectorGraphics.website,
                  onTap: () => cubit.openSocialMediaLink(website),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialMediaIcon extends StatelessWidget {
  const _SocialMediaIcon({
    required this.icon,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: AppDimens.l),
        child: InformedSvg(
          icon,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
