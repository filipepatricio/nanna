import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class ShouldWaitForUiActiveStateUseCase {
  ShouldWaitForUiActiveStateUseCase();

  Future<bool> call() => BehaviorSubject.seeded(true).firstWhere((isActive) => isActive);
}
