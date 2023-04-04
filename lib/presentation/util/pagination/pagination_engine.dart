const _defaultLimit = 10;

class NextPageConfig {
  NextPageConfig(this.limit, this.offset);
  final int limit;
  final int offset;
}

abstract class NextPageLoader<T> {
  Future<List<T>> call(NextPageConfig config);
}

class PaginationEngine<T> {
  PaginationEngine(this._nextPageLoader);
  final NextPageLoader<T> _nextPageLoader;
  final List<T> _data = [];
  int _limit = _defaultLimit;

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
    final allLoaded = data.isEmpty;
    _data.addAll(data);

    return PaginationEngineState(
      data: List.of(_data),
      allLoaded: allLoaded,
    );
  }
}

class PaginationEngineState<T> {
  PaginationEngineState({
    required this.data,
    required this.allLoaded,
  });
  final List<T> data;
  final bool allLoaded;
}
