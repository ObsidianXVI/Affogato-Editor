part of affogato.editor;

class AffogatoEditorFieldController extends TextEditingController {
  final AffogatoEditorConfigs editorConfigs;

  AffogatoEditorFieldController({required this.editorConfigs});

  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty,
    );
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    return TextSpan(
      style: editorConfigs.defaultTextStyle,
      text: text,
    );
  }
}
