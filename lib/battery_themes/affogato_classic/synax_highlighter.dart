part of affogato.editor.battery.themes.affogato;

class AffogatoSyntaxHighlighter extends SyntaxHighlighter<AffogatoRenderToken> {
  @override
  List<AffogatoRenderToken> createRenderTokens(AST ast) {
    final List<AffogatoRenderToken> renderTokens = [];
    for (final node in ast.nodes) {
      if (node.scopes.contains('heading.two') ||
          node.scopes.contains('heading.three')) {
        renderTokens.add(HeaderBoldRenderToken(node));
      } else if (node.scopes.contains('heading.one')) {
        renderTokens.add(HeaderOneRenderToken(node));
      } else if (node.scopes.contains('string')) {
        renderTokens.add(StringRenderToken(node));
      } else if (node.scopes.contains('number')) {
        renderTokens.add(NumberRenderToken(node));
      } else if (node.scopes.contains('keyword')) {
        renderTokens.add(KeywordRenderToken(node));
      } else if (node.scopes.contains('class')) {
        renderTokens.add(ClassRenderToken(node));
      } else if (node.scopes.contains('comment')) {
        renderTokens.add(CommentRenderToken(node));
      } else if (node.scopes.contains('built_in')) {
        renderTokens.add(BuiltInRenderToken(node));
      } else {
        renderTokens.add(DefaultPlainTextRenderToken(node));
      }
    }

    return renderTokens;
  }
}
