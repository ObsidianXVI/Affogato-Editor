part of affogato.editor.battery.markdown;

class MarkdownTokeniser extends Tokeniser {
  final List<Token> tokens = [];
  late Cursor cursor;
  CursorLocation? offset;

  @override
  List<Token> tokenise(
    String source, {
    List<Token> precedingTokens = const [],
    List<Token> succeedingTokens = const [],
  }) {
    cursor = Cursor(source);

    if (precedingTokens.isNotEmpty) {
      offset = precedingTokens.last.end;
    }

    tokenisingLoop();
    offset = null;
    return tokens;
  }

  void tokenisingLoop() {
    while (!cursor.reachedEOF) {
      tokens.add(
        switch (cursor.current) {
          '#' => Token(
              tokenType: TokenType.numberSign(),
              lexeme: TokenType.numberSign().value,
              start: cursor.location() + offset,
              end: (cursor..advance()).location() + offset),
          ' ' => Token(
              tokenType: TokenType.space(),
              lexeme: TokenType.space().value,
              start: cursor.location() + offset,
              end: (cursor..advance()).location() + offset),
          '\n' => Token(
              tokenType: TokenType.newline(),
              lexeme: TokenType.newline().value,
              start: cursor.location() + offset,
              end: (cursor..advance()).location() + offset),
          String() => Token(
              tokenType: TokenType.string(),
              lexeme: cursor.current,
              start: cursor.location() + offset,
              end: (cursor..advance()).location() + offset),
        },
      );
    }
    final CursorLocation eofLoc = CursorLocation(
        rowNum: cursor.location().rowNum, colNum: cursor.location().colNum + 1);
    tokens.add(Token(
      tokenType: TokenType.eof(),
      lexeme: TokenType.eof().value,
      start: eofLoc,
      end: eofLoc,
    ));
  }
}
