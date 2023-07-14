library affogato.parser;

import 'package:affogato/components/components.dart';
import 'package:affogato/engine/engine.dart';

class AffogatoLanguageBundle {
  final AffogatoTokeniser tokeniser;
  final AffogatoParser parser;
  final AffogatoLanguageTheme languageTheme;

  const AffogatoLanguageBundle({
    required this.tokeniser,
    required this.parser,
    required this.languageTheme,
  });
}

abstract class AffogatoTokeniser {
  List<AffogatoToken> tokenise(DocumentMap doc);
}

abstract class AffogatoParser {
  List<AffogatoParseObject> parse(List<AffogatoToken> tokens);
}

class AffogatoToken {
  final String lexeme;
  final CursorLocation start;

  const AffogatoToken({
    required this.lexeme,
    required this.start,
  });

  int get charCount => lexeme.length;
}

class AffogatoParseObject {
  final AffogatoScope scope;
  final List<AffogatoToken> tokens;
  final CellStyle cellStyle;

  const AffogatoParseObject({
    required this.scope,
    required this.tokens,
    required this.cellStyle,
  });
}

class AffogatoScope {
  final String name;

  const AffogatoScope({
    required this.name,
  });
}

class AffogatoLanguageTheme {
  final Map<AffogatoScope, CellStyle> scopeStyles;

  const AffogatoLanguageTheme({
    required this.scopeStyles,
  });
}
