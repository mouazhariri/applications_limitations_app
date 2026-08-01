sealed class Either<L, R> {
  const Either();

  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight);

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;

  L? get leftOrNull => switch (this) {
        Left<L, R>(:final value) => value,
        Right<L, R>() => null,
      };

  R? get rightOrNull => switch (this) {
        Right<L, R>(:final value) => value,
        Left<L, R>() => null,
      };
}

class Left<L, R> extends Either<L, R> {
  const Left(this.value);

  final L value;

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) => onLeft(value);
}

class Right<L, R> extends Either<L, R> {
  const Right(this.value);

  final R value;

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) => onRight(value);
}
