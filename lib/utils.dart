part of affogato.editor;

const Color afBrown = Color(0xFF1E0300);
const Color afCream = Color(0xFFEFDCCD);
const Color afRed = Color(0xFFC62202);
const Color afLightBrown3 = Color(0xFF744731);
const Color afLightBrown1 = Color.fromARGB(255, 183, 130, 104);

extension StringUtils on String {
  String insert(int newIndex, String char) =>
      substring(0, newIndex) + char + substring(newIndex, length);
  String delete(int index) => (characters.toList()..removeAt(index)).join();
}
