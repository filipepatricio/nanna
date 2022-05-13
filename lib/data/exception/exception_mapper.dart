abstract class ExceptionMapper {
  Object mapIfFits(Object original) {
    if (isFitting(original)) return map(original);
    return original;
  }

  bool isFitting(Object original);

  Object map(Object original);
}
