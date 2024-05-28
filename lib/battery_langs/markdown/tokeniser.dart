part of affogato.editor.battery.markdown;

class MDTokenType extends TokenType {
  MDTokenType(super.lexeme);

  MDTokenType.header1() : super('# Heading One');
}

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
/*     while (!cursor.reachedEOF) {
      print('calling tokLoop');

      tokenisingLoop();
    } */

    offset = null;
    return tokens;
  }

  void tokenisingLoop() {
    while (cursor.nextMatchesAny([' ', '\n'])) {
      cursor.skip();
    }
    if (cursor.nextMatches('#') && cursor.peek(2)[1] == ' ') {
      tokens.add(tokeniseHeader());
    }
  }

  Token tokeniseHeader() {
    final CursorLocation start = cursor.location(offset);
    final CursorLocation end;
    final List<Char> lexemeChars = [cursor.advance()];

    if (cursor.peek().first.isEOF || cursor.peek().first == '\n') {
      end = cursor.location(offset);
    } else {
      while (!(cursor.current == '\n' || cursor.reachedEOF)) {
        lexemeChars.add(cursor.advance());
      }
      end = cursor.location(offset);
    }

    return Token(
      tokenType: MDTokenType.header1(),
      lexeme: lexemeChars.join(),
      start: start,
      end: end,
    );
  }
}
