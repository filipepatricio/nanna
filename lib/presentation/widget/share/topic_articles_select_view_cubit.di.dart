import 'dart:io';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_text_use_case.di.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_using_facebook_use_case.di.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_using_instagram_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
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

  Future<void> shareImage(ShareApp shareApp) async {
    emit(TopicArticlesSelectViewState.generatingShareImage());

    late File image;

    if (shareApp == ShareApp.instagram || shareApp == ShareApp.facebook) {
      final articles = _selectedIndexes.map((e) => _topic.entries[e]).map((e) => e.item as MediaItemArticle).toList();

      ShareTopicView factory() => ShareTopicView(
            topic: _topic,
            articles: articles,
          );

      image = await generateShareImage(
        _shareViewImageGenerator,
        factory,
        '${_topic.id}_share_topic.png',
      );
    }

    switch (shareApp) {
      case ShareApp.instagram:
        await _shareUsingInstagramUseCase(image, null, _topic.url);
        break;
      case ShareApp.facebook:
        await _shareUsingFacebookUseCasel(image, _topic.url);
        break;
      default:
        await _shareTextUseCase(shareApp, _topic.url, _topic.strippedTitle);
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
