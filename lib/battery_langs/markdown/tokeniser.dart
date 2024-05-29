part of affogato.editor.battery.markdown;

class MDTokenType extends TokenType {
  MDTokenType(super.name);

  MDTokenType.header1() : super('Header 1');
  MDTokenType.body() : super('Body Text');
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
    offset = null;
    return tokens;
  }

  void tokenisingLoop() {
    while ([' ', '\n'].contains(cursor.current)) {
      cursor.skip();
    }

    while (!cursor.reachedEOF) {
      if (cursor.current == '#' && cursor.peek().first == ' ') {
        tokens.add(tokeniseHeader());
      } else if (cursor.current == '\n') {
        cursor.skip();
      } else {
        tokens.add(tokeniseBody());
      }
    }
  }

  Token tokeniseHeader() {
    final CursorLocation start = cursor.location() + offset;
    final CursorLocation end;
    final List<Char> lexemeChars = [];

    while (cursor.current != '\n') {
      if (cursor.reachedEOF) {
        lexemeChars.add(cursor.current);
        break;
      } else {
        lexemeChars.add(cursor.current);
        cursor.advance();
      }
    }

    end = cursor.location() + offset;

    return Token(
      tokenType: MDTokenType.header1(),
      lexeme: lexemeChars.join(),
      start: start,
      end: end,
    );
  }

  Token tokeniseBody() {
    final CursorLocation start = cursor.location() + offset;
    final CursorLocation end;
    final List<Char> lexemeChars = [];

    while (cursor.current != '\n') {
      if (cursor.reachedEOF) {
        lexemeChars.add(cursor.current);
        break;
      } else {
        lexemeChars.add(cursor.current);
        cursor.advance();
      }
    }

    end = cursor.location() + offset;

    return Token(
      tokenType: MDTokenType.body(),
      lexeme: lexemeChars.join(),
      start: start,
      end: end,
    );
  }
}
