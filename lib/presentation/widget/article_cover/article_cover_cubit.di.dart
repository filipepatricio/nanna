import 'dart:async';

import 'package:better_informed_mobile/domain/article/use_case/get_article_read_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/load_local_article_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/networking/use_case/is_internet_connection_available_use_case.di.dart';
import 'package:better_informed_mobile/presentation/util/connection_state_aware_cubit_mixin.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleCoverCubit extends Cubit<ArticleCoverState> with ConnectionStateAwareCubitMixin {
  ArticleCoverCubit(
    this._getShouldUpdateArticleProgressStateUseCase,
    this._isInternetConnectionAvailableUseCase,
    this._loadLocalArticleUseCase,
  ) : super(ArticleCoverState.initializing());

  final GetArticleReadStateStreamUseCase _getShouldUpdateArticleProgressStateUseCase;
  final IsInternetConnectionAvailableUseCase _isInternetConnectionAvailableUseCase;
  final LoadLocalArticleUseCase _loadLocalArticleUseCase;

  @override
  IsInternetConnectionAvailableUseCase get isInternetConnectionAvailableUseCase =>
      _isInternetConnectionAvailableUseCase;

  late MediaItemArticle _article;

  StreamSubscription? _shouldUpdateArticleProgressStateSubscription;

  @override
  Future<void> close() {
    _shouldUpdateArticleProgressStateSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize(MediaItemArticle article) async {
    _article = article;
    await _emitIdleOrOffline();

    _shouldUpdateArticleProgressStateSubscription =
        _getShouldUpdateArticleProgressStateUseCase(_article.id).listen((updatedArticle) {
      _article = updatedArticle;
      _emitIdleOrOffline();
    });

    await initializeConnection(null);
  }

  @override
  Future<void> onOffline(initialData) async {
    await state.mapOrNull(
      idle: (_) async {
        final localArticle = await _loadLocalArticleUseCase(_article.slug);
        if (localArticle == null) emit(ArticleCoverState.offline(_article));
      },
    );
  }

  @override
  Future<void> onOnline(initialData) async {
    state.mapOrNull(
      offline: (_) => emit(ArticleCoverState.idle(_article)),
    );
  }

  Future<void> _emitIdleOrOffline() async {
    if (!await _isInternetConnectionAvailableUseCase()) {
      final localArticle = await _loadLocalArticleUseCase(_article.slug);
      if (localArticle == null) {
        emit(ArticleCoverState.offline(_article));
        return;
      }
    }
    emit(ArticleCoverState.idle(_article));
  }
}
