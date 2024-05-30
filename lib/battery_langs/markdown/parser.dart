part of affogato.editor.battery.markdown;

class MarkdownParser extends Parser {
  late TokenCursor cursor;

  @override
  AST parse(List<Token> tokens) {
    cursor = TokenCursor(tokens);
    const AST ast = AST(nodes: []);

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
    // the final newline
    cursor.skip();
    return node;
  }

  BodyNode parseBody() {
    final node = BodyNode();
    while (cursor.current.tokenType != const TokenType.newline() &&
        !cursor.reachedEOF) {
      node.tokens.add(cursor.current);
      cursor.advance();
    }
    // the final newline
    cursor.skip();
    return node;
  }
}

class HeaderOneNode extends ASTNode {
  HeaderOneNode() : super('HeaderOneNode');
}

class BodyNode extends ASTNode {
  BodyNode() : super('BodyNode');
}
