/// A collection of useful functions that are not specific to any one domain.
class Prelude {
  /// Equivalent to `x == null ? null : f(x)`, or `x?.let(f)` in Kotlin syntax.
  static S? liftNull<T, S>(S Function(T) f, T? x) {
    if (x == null) {
      return null;
    }
    return f(x);
  }
}

/// Generic mutable pair class.
class Pair<T1, T2> {
  T1 first;
  T2 second;

  Pair(this.first, this.second);

  @override
  int get hashCode => first.hashCode * 31 + second.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Pair<T1, T2> && first == other.first && second == other.second;

  @override
  String toString() => '($first, $second)';
}
