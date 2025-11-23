// A quick workaround of a mutable tuple since Dart's records aren't mutable
class Pair<T, K> {
  T first;
  K second;

  Pair({required this.first, required this.second});
}
