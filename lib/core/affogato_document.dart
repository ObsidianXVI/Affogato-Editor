part of affogato.core;

class AffogatoDocument {
  final List<String> sourceLines;

  const AffogatoDocument({
    required this.sourceLines,
  });

  AffogatoDocument.fromString(String source) : sourceLines = source.split('\n');
}
