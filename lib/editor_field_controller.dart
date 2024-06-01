part of affogato.editor;

class AffogatoEditorFieldController extends TextEditingController {
  final LanguageBundle languageBundle;
  final ThemeBundle<AffogatoRenderToken, AffogatoSyntaxHighlighter> themeBundle;
  final AffogatoEditorConfigs editorConfigs;

  AffogatoEditorFieldController({
    required this.editorConfigs,
    required this.languageBundle,
    required this.themeBundle,
  });

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
    if (text.isNotEmpty) {
      final List<Token> tokens = languageBundle.tokeniser.tokenise(text);
      final AST newAST = languageBundle.parser.parse(tokens);
      final List<AffogatoRenderToken> renderTokens =
          themeBundle.synaxHighlighter.createRenderTokens(newAST);

      return TextSpan(
        style: editorConfigs.defaultTextStyle,
        children: [
          for (final rt in renderTokens)
            TextSpan(
              text: rt.node.lexeme,
              style: rt.render(),
            ),
        ],
      );
    } else {
      return TextSpan(
        text: text,
        style: editorConfigs.defaultTextStyle,
      );
    }
  }
}
