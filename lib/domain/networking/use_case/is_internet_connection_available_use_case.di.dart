import 'package:better_informed_mobile/domain/networking/connectivity_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class IsInternetConnectionAvailableUseCase {
  const IsInternetConnectionAvailableUseCase(
    this._connectivityRepository,
  );

  final ConnectivityRepository _connectivityRepository;

  Future<bool> call() async {
    return await _connectivityRepository.hasInternetConnection();
  }

  Stream<bool> get stream => _connectivityRepository.hasInternetConnectionStream;
}
