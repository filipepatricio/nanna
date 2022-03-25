const _defaultLimit = 10;

class NextPageConfig {
  final int limit;
  final int offset;

  NextPageConfig(this.limit, this.offset);
}

abstract class NextPageLoader<T> {
  Future<List<T>> call(NextPageConfig config);
}

class PaginationEngine<T> {
  final NextPageLoader<T> _nextPageLoader;
  final List<T> _data = [];
  int _limit = _defaultLimit;

  PaginationEngine(this._nextPageLoader);

  void initialize(List<T> initialData, {int limit = _defaultLimit}) {
    _data.addAll(initialData);
    _limit = limit;
  }

  Future<PaginationEngineState<T>> loadMore({int? limitOverride}) async {
    final config = NextPageConfig(limitOverride ?? _limit, _data.length);
    final result = await _nextPageLoader(config);

    return _onDataLoaded(result, config.limit);
  }

  List<T> removeItemAt(int index) {
    _data.removeAt(index);
    return List.of(_data);
  }

  List<T> insert(T element, int index) {
    _data.insert(index, element);
    return List.of(_data);
  }

  PaginationEngineState<T> _onDataLoaded(List<T> data, int requestedLimit) {
    final allLoaded = data.length < requestedLimit;
    _data.addAll(data);

    return PaginationEngineState(
      data: List.of(_data),
      allLoaded: allLoaded,
    );
  }
}

class PaginationEngineState<T> {
  final List<T> data;
  final bool allLoaded;

  PaginationEngineState({
    required this.data,
    required this.allLoaded,
  });
}
