/// String Extension methods
extension StringExtensions on String {
  /// Capitalizes the first letter of the string.
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;

  /// Checks if the string is a valid email.
  bool get isValidEmail {
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(this);
  }

  /// Converts a string to title case.
  String toTitleCase() => split(' ')
      .map(
        (String word) => word.capitalize(),
      )
      .join(' ');

  /// Truncates the string to a specified length, adding an ellipsis if needed.
  String truncate(int length) =>
      (length < this.length) ? '${substring(0, length)}...' : this;

  /// Checks if the string is a valid numeric value.
  bool get isNumeric => double.tryParse(this) != null;
}
