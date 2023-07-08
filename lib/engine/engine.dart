library affogato.engine;

import 'package:affogato/components/components.dart';
import 'package:affogato/parser/parser.dart';

part './affogato_document.dart';

class AffogatoEngine {
  final AffogatoDocument document;
  final AffogatoLanguageBundle languageBundle;
  final AffogatoEditor editor;

  const AffogatoEngine({
    required this.document,
    required this.languageBundle,
    required this.editor,
  });
}
