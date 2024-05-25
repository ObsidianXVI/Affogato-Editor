part of affogato.editor;

extension StringUtils on String {
  String insert(int index, String string) => replaceRange(index, index, string);
}