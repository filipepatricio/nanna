abstract class BidirectionalMapper<A, B> {
  B to(A data);

  A from(B data);
}
