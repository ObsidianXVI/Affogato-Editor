library affogato.parser;

import 'package:affogato/components/components.dart';

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
  List<AffogatoToken> tokenise(List<String> chars);
}

abstract class AffogatoParser {
  List<AffogatoParseObject> parse(List<AffogatoToken> tokens);
}

class AffogatoToken {
  final String lexeme;
  final Cursor pos;

  const AffogatoToken({
    required this.lexeme,
    required this.pos,
  });
}

class AffogatoParseObject {
  final AffogatoScope scope;

  const AffogatoParseObject({
    required this.scope,
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
