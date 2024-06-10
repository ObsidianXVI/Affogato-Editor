part of affogato.editor;

class AffogatoEditorFieldController<T extends AffogatoRenderToken,
    H extends SyntaxHighlighter<T>> extends TextEditingController {
  final LanguageBundle languageBundle;
  final ThemeBundle<T, H> themeBundle;
  final AffogatoEditorConfigs editorConfigs;
  String oldText = '';

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
    Delta? delta;
    if (text.isNotEmpty) {
      final int cursorCurrentPos = selection.start;
      if (text.length > oldText.length) {
        delta = Delta.insertion(
            char: text[cursorCurrentPos - 1], pos: cursorCurrentPos);
      } else if (text.length < oldText.length) {
        delta = Delta.deletion(
            char: oldText[cursorCurrentPos], pos: cursorCurrentPos);
      }
    }

    if (delta != null) {
      for (final deltaInterceptor in editorConfigs.deltaInterceptors) {
        deltaInterceptor.handleDelta(delta, this);
      }
    }

    oldText = text;

    if (text.isNotEmpty) {
      try {
        final List<Token> tokens = languageBundle.tokeniser.tokenise(text);
        final ParseResult res = languageBundle.parser.parse(tokens);
        final List<AffogatoRenderToken> renderTokens =
            themeBundle.synaxHighlighter.createRenderTokens(res);
        return TextSpan(
          style: editorConfigs.defaultTextStyle,
          children: [
            for (final rt in renderTokens)
              TextSpan(
                text: (rt.node as TerminalASTNode).lexeme,
                style: rt.render(editorDefaultStyle),
              ),
          ],
        );
      } catch (e, st) {
        print(e);
        //print(st);
      }
      return TextSpan(
        text: text,
        style: editorConfigs.defaultTextStyle,
      );
    } else {
      return TextSpan(
        text: text,
        style: editorConfigs.defaultTextStyle,
      );
    }
  }
}
