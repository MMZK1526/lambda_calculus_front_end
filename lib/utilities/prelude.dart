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
