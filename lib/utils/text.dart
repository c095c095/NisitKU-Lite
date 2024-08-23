/// Capitalizes the first letter of the given [text].
///
/// If the [text] is empty, it returns an empty string.
/// Otherwise, it converts the [text] to lowercase and capitalizes the first letter.
/// The rest of the letters remain unchanged.
///
/// Example:
/// ```dart
/// String result = capitalize("hello");
/// print(result); // Output: "Hello"
/// ```
String capitalize(String text) {
  if (text.isEmpty) {
    return text;
  }
  text = text.toLowerCase();
  return text[0].toUpperCase() + text.substring(1);
}
