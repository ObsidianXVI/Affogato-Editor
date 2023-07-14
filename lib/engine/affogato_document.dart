part of affogato.engine;

class AffogatoDocument {
  final DocumentMap documentMap;

  const AffogatoDocument({
    required this.documentMap,
  });

  AffogatoDocument.fromString(String source)
      : documentMap = DocumentMap(source: source);
}

class DocumentMap {
  CursorLocation currentLocation = CursorLocation(row: 0, col: 0);
  late final List<List<String>> chars =
      source.split('\n').map((String line) => line.split('')).toList();
  late final int totalLines = chars.length;
  final String source;
  final List<List<CharCellComponent>> cells = [];

  DocumentMap({
    required this.source,
  });

  String charAt(CursorLocation loc) => chars[loc.row][loc.col];
}
