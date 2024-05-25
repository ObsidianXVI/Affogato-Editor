part of affogato.editor;

enum DeltaType {
  deletion,
  insertion,
}

class Delta {
  final DeltaType deltaType;
  final String char;
  final int pos;

  const Delta.insertion({
    required this.char,
    required this.pos,
  }) : deltaType = DeltaType.insertion;

  const Delta.deletion({
    required this.char,
    required this.pos,
  }) : deltaType = DeltaType.deletion;
}

abstract class DeltaInterceptor {
  const DeltaInterceptor();
  void handleDelta(Delta delta, AffogatoEditorFieldController controller);
}

class PairMatcher extends DeltaInterceptor {
  const PairMatcher();

  @override
  void handleDelta(Delta delta, AffogatoEditorFieldController controller) {
    if (delta.deltaType == DeltaType.insertion) {
      final String? matchingChar = switch (delta.char) {
        '(' => ')',
        '[' => ']',
        '{' => '}',
        '"' => '"',
        "'" => "'",
        '<' => '>',
        String() => null,
      };
      if (matchingChar != null) {
        controller.text = controller.text.insert(delta.pos + 1, matchingChar);
        controller.selection = TextSelection.collapsed(offset: delta.pos + 1);
      }
    }
  }
}
