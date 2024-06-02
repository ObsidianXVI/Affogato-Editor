part of affogato.editor.battery.generic;

class GenericParser extends Parser {
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
    final ASTNode node = switch (cursor.current.tokenType.value) {
      'keyword' => HLJSKeywordNode()..tokens.add(cursor.current),
      'built_in' => HLJSBuiltInNode()..tokens.add(cursor.current),
      'comment' => HLJSCommentNode()..tokens.add(cursor.current),
      'string' => HLJSStringNode()..tokens.add(cursor.current),
      'number' => HLJSNumberNode()..tokens.add(cursor.current),
      'class' => HLJSClassNode()..tokens.add(cursor.current),
      String() => GenericUnkownNode()..tokens.add(cursor.current),
    };
    cursor.advance();
    return node;
  }
}

class HLJSKeywordNode extends ASTNode {
  HLJSKeywordNode() : super('HLJSKeywordNode', scopes: ['keyword']);
}

class HLJSBuiltInNode extends ASTNode {
  HLJSBuiltInNode() : super('HLJSBuiltInNode', scopes: ['built_in']);
}

class HLJSCommentNode extends ASTNode {
  HLJSCommentNode() : super('HLJSCommentNode', scopes: ['comment']);
}

class HLJSStringNode extends ASTNode {
  HLJSStringNode() : super('HLJSStringNode', scopes: ['string']);
}

class HLJSNumberNode extends ASTNode {
  HLJSNumberNode() : super('HLJSNumberNode', scopes: ['number']);
}

class HLJSClassNode extends ASTNode {
  HLJSClassNode() : super('HLJSClassNode', scopes: ['class']);
}

class GenericUnkownNode extends ASTNode {
  GenericUnkownNode() : super('GenericUnkownNode', scopes: ['unkown']);
}
