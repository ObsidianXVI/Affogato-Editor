part of affogato.editor.battery.themes.affogato;

class AffogatoSyntaxHighlighter extends SyntaxHighlighter<AffogatoRenderToken> {
  @override
  List<AffogatoRenderToken> createRenderTokens(AST ast) {
    final List<AffogatoRenderToken> renderTokens = [];

    for (final node in ast.nodes) {
      if (node.scopes.contains('heading')) {
        renderTokens.add(HeaderBoldRenderToken(node));
      } else if (node.scopes.contains('string')) {
        renderTokens.add(DefaultPlainTextRenderToken(node));
      } else {
        renderTokens.add(DefaultPlainTextRenderToken(node));
      }
    }

    return renderTokens;
  }
}
