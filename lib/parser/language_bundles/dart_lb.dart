import 'package:affogato/components/components.dart';
import 'package:affogato/engine/engine.dart';
import 'package:affogato/parser/parser.dart';

enum DartTokenType {
  identifier,
  keyword,
}

class DartLanguageBundle extends AffogatoLanguageBundle {
  DartLanguageBundle({
    required super.languageTheme,
  }) : super(
          parser: DartParser(),
          tokeniser: DartTokeniser(),
        );
}

class DartTokeniser extends AffogatoTokeniser {
  @override
  List<AffogatoToken> tokenise(DocumentMap doc) {
    final List<DartToken> tokens = [];
    if (doc.peekChar() == 'c') {
      final CursorLocation startCI = doc.currentLocation;
      tokens.add(
        DartToken(
          lexeme: doc.consumeUntil(' ').join(),
          start: startCI,
          tokenType: DartTokenType.keyword,
        ),
      );
      doc.consumeChar();
    }

    if (doc.peekChar().isAlphaNum) {
      final CursorLocation startCN = doc.currentLocation;
      tokens.add(
        DartToken(
          lexeme: doc.consumeUntil(' ').join(),
          start: startCN,
          tokenType: DartTokenType.identifier,
        ),
      );
      doc.consumeChar();
    }

    return tokens;
  }
}

class DartParser extends AffogatoParser {
  @override
  List<AffogatoParseObject> parse(List<AffogatoToken> tokens) {
    tokens as List<DartToken>;
    final List<AffogatoParseObject> parseObjects = [];

    for (DartToken token in tokens) {
      if (token.tokenType == DartTokenType.identifier) {
        parseObjects.add(
          AffogatoParseObject(
            scope: AffogatoScope(name: 'name'),
            tokens: [token],
            cellStyle: CellStyle(),
          ),
        );
      }
    }

    return parseObjects;
  }
}

class DartToken extends AffogatoToken {
  final DartTokenType tokenType;

  const DartToken({
    required this.tokenType,
    required super.lexeme,
    required super.start,
  });
}
