import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

GetIt useGetIt() {
  final context = useContext();
  return useMemoized(
    () => context.read<GetIt>(),
    [context],
  );
}
