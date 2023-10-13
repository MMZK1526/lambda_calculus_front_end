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
