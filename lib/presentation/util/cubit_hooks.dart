import 'package:better_informed_mobile/presentation/util/di_util.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

abstract class CubitFactory<C extends Cubit> {
  C create();
}

abstract class BuildState {}

typedef OnCubitCreate<F extends CubitFactory> = Function(F factory);
typedef BlocBuilderCondition<S> = bool Function(S current);
typedef BlocListener<BLOC extends Cubit<S>, S> = void Function(BLOC cubit, S current, BuildContext context);

class _CubitDefaults {
  static bool defaultBlocBuilderCondition<S>(S state) => state is BuildState;

  static bool defaultBlocListenCondition<S>(S state) => true;
}

T useCubit<T extends Cubit>({bool closeOnDispose = true, List<dynamic> keys = const <dynamic>[]}) {
  final getIt = useGetIt();
  final cubit = useMemoized(() => getIt<T>(), keys);
  useEffect(
    () {
      return closeOnDispose ? cubit.close : null;
    },
    [cubit],
  );
  return cubit;
}

T useCubitFactory<T extends Cubit, F extends CubitFactory<T>>({
  OnCubitCreate<F>? onCubitCreate,
  bool closeOnDispose = true,
  List<dynamic> keys = const <dynamic>[],
}) {
  final getIt = useGetIt();
  final factory = useMemoized(() => getIt<F>(), keys);
  final cubit = useMemoized(
    () {
      onCubitCreate?.call(factory);
      return factory.create();
    },
    [factory],
  );

  useEffect(
    () {
      return closeOnDispose ? cubit.close : null;
    },
    [cubit],
  );

  return cubit;
}

T useCubitWithParams<T extends Cubit>(param1, param2, [List<dynamic> keys = const <dynamic>[]]) {
  final getIt = useGetIt();
  final cubit = useMemoized(() => getIt.get<T>(param1: param1, param2: param2), keys);
  useEffect(() => cubit.close, [cubit]);
  return cubit;
}

S useCubitBuilder<C extends Cubit, S>(
  Cubit<S> cubit, {
  BlocBuilderCondition<S>? buildWhen,
}) {
  final buildWhenConditioner = buildWhen;
  final state = useMemoized(
    () => cubit.stream.where(buildWhenConditioner ?? _CubitDefaults.defaultBlocBuilderCondition),
    [cubit],
  );
  return useStream(
    state,
    initialData: cubit.state,
    preserveState: false,
  ).requireData!;
}

void useCubitListener<BLOC extends Cubit<S>, S>(
  BLOC cubit,
  BlocListener<BLOC, S> listener, {
  BlocBuilderCondition<S>? listenWhen,
}) {
  final context = useContext();
  final listenWhenConditioner = listenWhen;
  useMemoized(
    () {
      final stream = cubit.stream
          .where(listenWhenConditioner ?? _CubitDefaults.defaultBlocListenCondition)
          .listen((state) => listener(cubit, state, context));
      return stream.cancel;
    },
    [cubit],
  );
}
