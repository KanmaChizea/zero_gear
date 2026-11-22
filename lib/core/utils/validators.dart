abstract final class Validator {
  static String? wholeNumberInRange(
    String value, {
    required String label,
    required int min,
    required int max,
  }) {
    final number = int.tryParse(value.trim());
    if (number == null) return 'Enter your $label';
    if (number < min || number > max) {
      return '$label must be between $min and $max';
    }
    return null;
  }

  static String? height(String value) =>
      wholeNumberInRange(value, label: 'Height', min: 50, max: 250);

  static String? weight(String value) =>
      wholeNumberInRange(value, label: 'Weight', min: 20, max: 300);
}
