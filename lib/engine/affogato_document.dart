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
  CursorLocation currentLocation = const CursorLocation(row: 0, col: 0);
  late final List<List<String>> chars =
      source.split('\n').map((String line) => line.split('')).toList();
  late final int totalLines = chars.length;
  final String source;
  final List<List<CharCellComponent>> cells = [];

  DocumentMap({
    required this.source,
  });

  String charAt(CursorLocation loc) => chars[loc.row][loc.col];

  List<String> get currentLineChars => chars[currentLocation.row];
  List<List<String>> get charMapFromCurrent {
    final List<List<String>> rowsLeft = chars.sublist(currentLocation.row);
    if (rowsLeft.isNotEmpty) {
      rowsLeft.first.removeRange(0, currentLocation.col - 1);
    }
    return rowsLeft;
  }

  List<String> get charListFromCurrent {
    final List<List<String>> rowsLeft = chars.sublist(currentLocation.row);
    if (rowsLeft.isNotEmpty) {
      rowsLeft.first.removeRange(0, currentLocation.col - 1);
    }
    return [for (List<String> r in rowsLeft) ...r];
  }

  CursorLocation moveCursor(
    int positions, [
    void Function(List<String>)? addChars,
  ]) {
    CursorLocation finalLoc = currentLocation;
    final int newPos = currentLocation.col + positions;
    final List<String> currentRow = chars[currentLocation.row];
    if (newPos > currentRow.length) {
      finalLoc += const CursorLocation(row: 1, col: 0);
      final int remPos = newPos - currentRow.length;
      return moveCursor(remPos, addChars);
    } else if (newPos < currentRow.length) {
      finalLoc += const CursorLocation(row: -1, col: 0);
      final int remPos = newPos + currentRow.length;
      return moveCursor(remPos, addChars);
    } else {
      return finalLoc + CursorLocation(row: 0, col: positions);
    }
  }
}

const List<String> _alphabets = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
  '_',
];
const List<String> _numbers = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '0'
];

extension StringUtils on String {
  bool get isAlpha {
    return _alphabets.contains(this);
  }

  bool get isNum {
    return _numbers.contains(this);
  }

  bool get isAlphaNum => isAlpha || isNum;
}
