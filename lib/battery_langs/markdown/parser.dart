part of affogato.editor.battery.langs.markdown;

class MarkdownParser extends Parser {
  late TokenCursor cursor;

  @override
  AST parse(List<Token> tokens) {
    cursor = TokenCursor(tokens);
    AST ast = AST(nodes: []);

    while (!cursor.reachedEOF) {
      ast.nodes.add(parseStatement());
    }

    return ast;
  }

  ASTNode parseStatement() {
    if (cursor.current.tokenType == const TokenType.numberSign()) {
      return cursor.peek().first.tokenType == const TokenType.space()
          ? parseHeaderOne()
          : parseBody();
    } else {
      return parseBody();
    }
  }

  HeaderOneNode parseHeaderOne() {
    final node = HeaderOneNode()
      ..tokens.addAll([cursor.current, cursor.advance()]);
    cursor.advance();
    while (cursor.current.tokenType != const TokenType.newline() &&
        !cursor.reachedEOF) {
      node.tokens.add(cursor.current);
      cursor.advance();
    }

    if (cursor.current.tokenType == const TokenType.newline()) {
      node.tokens.add(cursor.current);
      cursor.skip();
    }
    return node;
  }

  BodyNode parseBody() {
    final node = BodyNode();
    while (cursor.current.tokenType != const TokenType.newline() &&
        !cursor.reachedEOF) {
      node.tokens.add(cursor.current);
      cursor.advance();
    }
    if (cursor.current.tokenType == const TokenType.newline()) {
      node.tokens.add(cursor.current);
      cursor.skip();
    }
    return node;
  }
}

class HeaderOneNode extends ASTNode {
  HeaderOneNode() : super('HeaderOneNode', scopes: ['heading']);
}

class BodyNode extends ASTNode {
  BodyNode() : super('BodyNode', scopes: ['string']);
}
