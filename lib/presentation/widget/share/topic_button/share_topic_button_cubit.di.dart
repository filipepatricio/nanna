import 'dart:io';

import 'package:better_informed_mobile/domain/share/data/share_content.dt.dart';
import 'package:better_informed_mobile/domain/share/data/share_options.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_content_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_util.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_view_image_generator.di.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic/share_topic_view.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

enum ShareTopicButtonState { idle, processing, copiedMessage }

@injectable
class ShareTopicButtonCubit extends Cubit<ShareTopicButtonState> {
  ShareTopicButtonCubit(
    this._shareContentUseCase,
    this._shareViewImageGenerator,
  ) : super(ShareTopicButtonState.idle);

  final ShareContentUseCase _shareContentUseCase;
  final ShareViewImageGenerator _shareViewImageGenerator;

  Future<void> share(ShareOption? shareOption, TopicPreview topic) async {
    if (shareOption == null) return;

    ShareContent shareContent;

    switch (shareOption) {
      case ShareOption.instagram:
        final images = await Future.wait(
          [
            _generateForegroundImage(topic),
            _generateBackgroundImage(topic),
          ],
        );

        shareContent = ShareContent.instagram(
          images[0],
          images[1],
          topic.url,
        );
        break;
      case ShareOption.facebook:
        shareContent = ShareContent.facebook(
          await _generateCombinedImage(topic),
          topic.url,
        );
        break;
      case ShareOption.copyLink:
        shareContent = ShareContent.text(
          shareOption,
          topic.url,
          topic.strippedTitle,
        );
        emit(ShareTopicButtonState.copiedMessage);
        break;
      default:
        shareContent = ShareContent.text(
          shareOption,
          topic.url,
          topic.strippedTitle,
        );
        break;
    }

    await _shareContentUseCase(shareContent);

    emit(ShareTopicButtonState.idle);
  }

  Future<File> _generateForegroundImage(TopicPreview topic) async {
    ShareTopicStickerView factory() => ShareTopicStickerView(topic: topic);

    return generateShareImage(
      _shareViewImageGenerator,
      factory,
      '${topic.id}_sticker_topic.png',
    );
  }

  Future<File> _generateBackgroundImage(TopicPreview topic) async {
    ShareTopicBackgroundView factoryEmptyImage() => ShareTopicBackgroundView(topic: topic);

    return generateShareImage(
      _shareViewImageGenerator,
      factoryEmptyImage,
      '${topic.id}_background_topic.png',
    );
  }

  Future<File> _generateCombinedImage(TopicPreview topic) async {
    ShareTopicCombinedView factoryEmptyImage() => ShareTopicCombinedView(topic: topic);

    return generateShareImage(
      _shareViewImageGenerator,
      factoryEmptyImage,
      '${topic.id}_combined_topic.png',
    );
  }
}
