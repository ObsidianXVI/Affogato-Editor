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
      switch (cursor.peek().first.tokenType) {
        case const TokenType.space():
          return parseHeaderOne();
        case const TokenType.numberSign():
          final nextTwoTokens = cursor.peek(lookAhead: 2);
          if (nextTwoTokens[1].tokenType == const TokenType.numberSign()) {
            final nextThreeTokens = cursor.peek(lookAhead: 3);
            if (nextThreeTokens[2].tokenType == const TokenType.space()) {
              return parseHeaderThree();
            } else {
              return parseBody();
            }
          } else if (nextTwoTokens[1].tokenType == const TokenType.space()) {
            return parseHeaderTwo();
          } else {
            return parseBody();
          }
        default:
          return parseBody();
      }
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

  HeaderTwoNode parseHeaderTwo() {
    final node = HeaderTwoNode()
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

  HeaderThreeNode parseHeaderThree() {
    final node = HeaderThreeNode()
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
  HeaderOneNode() : super('HeaderOneNode', scopes: ['heading', 'heading.one']);
}

class HeaderTwoNode extends ASTNode {
  HeaderTwoNode() : super('HeaderTwoNode', scopes: ['heading', 'heading.two']);
}

class HeaderThreeNode extends ASTNode {
  HeaderThreeNode()
      : super('HeaderThreeNode', scopes: ['heading', 'heading.three']);
}

class BodyNode extends ASTNode {
  BodyNode() : super('BodyNode', scopes: ['string']);
}
