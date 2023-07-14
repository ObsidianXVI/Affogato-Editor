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

  String consumeChar([int count = 1]) {
    final List<String> consumedChars = [];
    currentLocation += advanceCursor(
      count,
      (List<String> newChars) => consumedChars.addAll(newChars),
    );
    return consumedChars.first;
  }

  List<String> consumeUntil(String stopChar) {
    final List<String> consumedChars = [];
    while (peekChar() != stopChar) {
      consumedChars.add(consumeChar());
    }
    return consumedChars;
  }

  String peekChar([int lookAhead = 1]) {
    final List<String> consumedChars = [];
    advanceCursor(
      lookAhead,
      (List<String> newChars) => consumedChars.addAll(newChars),
    );
    return consumedChars.last;
  }

  CursorLocation advanceCursor(
    int count, [
    void Function(List<String>)? addChars,
  ]) {
    List<String> currentRow = chars[currentLocation.row];
    final int rowLength = currentRow.length;
    if (count < rowLength) {
      addChars?.call(currentRow.sublist(0, count));
      return currentLocation + CursorLocation(row: 0, col: count);
    } else {
      CursorLocation newLoc = currentLocation;
      while (true) {
        newLoc = CursorLocation(row: newLoc.row + 1, col: 0);
        addChars?.call(currentRow);
        currentRow.clear();
        currentRow = chars[newLoc.row];
        if (count < currentRow.length) {
          addChars?.call(currentRow.sublist(0, count));
          return newLoc + CursorLocation(row: 0, col: count);
        } else {
          count -= currentRow.length;
        }
      }
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
