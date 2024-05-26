part of affogato.editor;

extension StringUtils on String {
  String insert(int newIndex, String char) =>
      substring(0, newIndex) + char + substring(newIndex, length);
  String delete(int index) => (characters.toList()..removeAt(index)).join();
}
