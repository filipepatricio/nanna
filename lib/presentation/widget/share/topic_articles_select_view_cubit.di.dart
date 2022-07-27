import 'dart:io';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_text_use_case.di.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_using_facebook_use_case.di.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_using_instagram_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/widget/share/empty_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_util.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_view_image_generator.di.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic/share_topic_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic_articles_select_view_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

const articlesSelectionLimit = 3;

@injectable
class TopicArticlesSelectViewCubit extends Cubit<TopicArticlesSelectViewState> {
  TopicArticlesSelectViewCubit(
    this._shareViewImageGenerator,
    this._shareTextUseCase,
    this._shareUsingInstagramUseCase,
    this._shareUsingFacebookUseCasel,
  ) : super(TopicArticlesSelectViewState.initializing());

  final ShareTextUseCase _shareTextUseCase;
  final ShareViewImageGenerator _shareViewImageGenerator;
  final ShareUsingInstagramUseCase _shareUsingInstagramUseCase;
  final ShareUsingFacebookUseCase _shareUsingFacebookUseCasel;

  late Topic _topic;
  final Set<int> _selectedIndexes = {};

  Future<void> initialize(Topic topic) async {
    _topic = topic;
    _emitIdleState();
  }

  void selectArticle(int index) {
    _selectedIndexes.add(index);

    _emitIdleState();
  }

  void unselectArticle(int index) {
    _selectedIndexes.remove(index);

    _emitIdleState();
  }

  Future<void> shareImage(ShareOptions shareOption) async {
    emit(TopicArticlesSelectViewState.generatingShareImage());

    late File image;
    late File emptyImage;

    if (shareOption == ShareOptions.instagram || shareOption == ShareOptions.facebook) {
      final articles = _selectedIndexes.map((e) => _topic.entries[e]).map((e) => e.item as MediaItemArticle).toList();

      ShareTopicView factory() => ShareTopicView(
            topic: _topic,
            articles: articles,
          );

      EmptyView factoryEmptyImage() => EmptyView();

      emptyImage = await generateShareImage(
        _shareViewImageGenerator,
        factoryEmptyImage,
        'empty_image.png',
      );

      image = await generateShareImage(
        _shareViewImageGenerator,
        factory,
        '${_topic.id}_share_topic.png',
      );
    }

    switch (shareOption) {
      case ShareOptions.instagram:
        await _shareUsingInstagramUseCase(emptyImage, image, _topic.url);
        break;
      case ShareOptions.facebook:
        await _shareUsingFacebookUseCasel(image, _topic.url);
        break;
      default:
        await _shareTextUseCase(shareOption, _topic.url, _topic.strippedTitle);
        break;
    }

    emit(TopicArticlesSelectViewState.shared());
  }

  void _emitIdleState() {
    emit(
      TopicArticlesSelectViewState.idle(
        _canSelectMore(),
        _topic.entries.map((entry) => entry.item).whereType<MediaItemArticle>().toList(),
        Set.from(_selectedIndexes),
        articlesSelectionLimit,
      ),
    );
  }

  bool _canSelectMore() => _selectedIndexes.length < articlesSelectionLimit;
}
