import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/topic_owner_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/topic_owner_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/widgets/last_updated_topics.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TopicOwnerPage extends HookWidget {
  const TopicOwnerPage({
    required this.owner,
    this.fromTopicSlug,
    Key? key,
  }) : super(key: key);

  final TopicOwner owner;
  final String? fromTopicSlug;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TopicOwnerPageCubit>();
    final state = useCubitBuilder(cubit);
    final cardStackHeight =
        MediaQuery.of(context).size.width * 0.5 > 450 ? MediaQuery.of(context).size.width * 0.5 : 450.0;
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

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimens.m)),
        child: Material(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _ActionsBar(controller: scrollController, owner: owner),
              Flexible(
                child: ListView(
                  physics: getPlatformScrollPhysics(),
                  controller: scrollController,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                          child: TopicOwnerAvatar(
                            owner: owner,
                            textStyle: AppTypography.h4Bold,
                            imageSize: AppDimens.avatarSize * 1.3,
                          ),
                        ),
                        const SizedBox(height: AppDimens.m),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                          child: Text(
                            owner.bio,
                            softWrap: true,
                            style: AppTypography.b1MediumLora,
                          ),
                        ),
                        if (owner is! EditorialTeam) ...[
                          _AnimatedSwitcher(
                            child: state.maybeMap(
                              idleExpert: (state) => state.topics.isEmpty
                                  ? const SizedBox.shrink()
                                  : LastUpdatedTopics(
                                      topics: state.topics,
                                      cardStackHeight: cardStackHeight,
                                    ),
                              idleEditor: (state) => state.topics.isEmpty
                                  ? const SizedBox.shrink()
                                  : LastUpdatedTopics(
                                      topics: state.topics,
                                      cardStackHeight: cardStackHeight,
                                    ),
                              orElse: () => const SizedBox.shrink(),
                            ),
                          ),
                          const SizedBox(height: AppDimens.xxl),
                        ],
                        if (owner is! Expert) ...[
                          const SizedBox(height: AppDimens.xl),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                            child: FilledButton(
                              text: LocaleKeys.topic_howDoWeCurateContent_label.tr(),
                              fillColor: AppColors.textPrimary,
                              textColor: AppColors.white,
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColors.white,
                                size: AppDimens.ml,
                              ),
                              onTap: () {
                                context.pushRoute(const HowDoWeCurateContentPageRoute());
                              },
                            ),
                          ),
                          const SizedBox(height: AppDimens.xl),
                        ],
                        if (owner is Expert && (owner as Expert).hasSocialMediaLinks) ...[
                          _SocialMediaLinks(
                            cubit: cubit,
                            owner: owner as Expert,
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
    );
  }
}

class _ActionsBar extends HookWidget {
  const _ActionsBar({
    required this.controller,
    required this.owner,
    Key? key,
  }) : super(key: key);

  final TopicOwner owner;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final showOwnerTitle = useState(0.0);

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
      height: kToolbarHeight + AppDimens.m,
      color: AppColors.background,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: AppDimens.ml,
            child: IconButton(
              icon: const Icon(Icons.close_rounded),
              color: AppColors.black,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
              onPressed: () => context.popRoute(),
            ),
          ),
          if (owner is! EditorialTeam)
            Positioned(
              right: AppDimens.ml,
              child: AnimatedOpacity(
                opacity: 1 - showOwnerTitle.value,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.xs),
                    color: owner is Editor ? AppColors.limeGreen : AppColors.peach,
                  ),
                  child: Text(
                    owner is Expert
                        ? LocaleKeys.topic_owner_expertIn.tr(args: [(owner as Expert).areaOfExpertise])
                        : LocaleKeys.topic_owner_editorialTeam.tr(),
                    style: AppTypography.topicOwnerLabelText,
                  ),
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
  final Expert owner;

  @override
  Widget build(BuildContext context) {
    final instagram = owner.instagram;
    final linkedin = owner.linkedin;
    final website = owner.website;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
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
                  onTap: () {
                    cubit.openSocialMediaLink(instagram);
                  },
                ),
              if (linkedin != null)
                _SocialMediaIcon(
                  icon: AppVectorGraphics.linkedin,
                  onTap: () {
                    cubit.openSocialMediaLink(linkedin);
                  },
                ),
              if (website != null)
                _SocialMediaIcon(
                  icon: AppVectorGraphics.website,
                  onTap: () {
                    cubit.openSocialMediaLink(website);
                  },
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
        child: SvgPicture.asset(
          icon,
          color: AppColors.socialNetworksIcon,
        ),
      ),
    );
  }
}

class _AnimatedSwitcher extends StatelessWidget {
  const _AnimatedSwitcher({required this.child, Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return kIsTest
        ? child
        : AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child: child,
          );
  }
}
