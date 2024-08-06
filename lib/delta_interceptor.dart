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
      if (delta.deltaType == DeltaType.insertion) {
        controller.text = controller.text.insert(delta.pos, matchingChar);
        controller.selection = TextSelection.collapsed(offset: delta.pos);
      } else if (delta.deltaType == DeltaType.deletion &&
          controller.text[delta.pos] == matchingChar) {
        controller.text = controller.text.delete(delta.pos);
        controller.selection = TextSelection.collapsed(offset: delta.pos);
      }
    }
  }
}

class AutoIndentor extends DeltaInterceptor {
  const AutoIndentor();

  @override
  void handleDelta(Delta delta, AffogatoEditorFieldController controller) {
    if (delta.deltaType == DeltaType.insertion &&
        delta.char == '\n' &&
        delta.pos >= 2 &&
        controller.text[delta.pos - 2] == '{') {
      controller.text = controller.text.insert(delta.pos, '    \n');
      controller.selection = TextSelection.collapsed(offset: delta.pos + 4);
    }
  }
}
