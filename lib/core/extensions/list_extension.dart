/// List Extension methods
extension ListExtensions<T> on List<T> {
  /// Returns the first element or `null` if the list is empty.
  T? get firstOrNull => isNotEmpty ? first : null;

  /// Returns the last element or `null` if the list is empty.
  T? get lastOrNull => isNotEmpty ? last : null;

  /// Groups the list into sublist of the specified size.
  List<List<T>> chunked(int size) {
    final List<List<T>> chunks = <List<T>>[];
    for (int i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }
}
