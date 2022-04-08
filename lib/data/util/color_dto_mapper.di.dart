import 'package:better_informed_mobile/data/mapper.dart';
import 'package:injectable/injectable.dart';

@injectable
class ColorDTOMapper implements Mapper<String, int> {
  @override
  int call(String data) {
    return int.parse('FF${data.replaceAll('#', '')}', radix: 16);
  }
}
