part of affogato.components;

class Cursor extends StatefulWidget {
  final AffogatoDocument document;
  final ValueNotifier<CursorLocation> cursorLocationNotifier;

  Cursor({
    required this.document,
    required CursorLocation initialLoc,
    super.key,
  }) : cursorLocationNotifier = ValueNotifier(initialLoc);

  @override
  State<StatefulWidget> createState() => CursorState();

  CursorLocation get currentLoc => cursorLocationNotifier.value;

  void moveToLocation(CursorLocation location) {
    cursorLocationNotifier.value = location;
  }
}

class CursorState extends State<Cursor> {
  late final Timer timer;
  Color color = Colors.green;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        color = color == Colors.green ? Colors.transparent : Colors.green;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: 18,
      width: 2,
      curve: Curves.easeIn,
      decoration: BoxDecoration(
        color: color,
      ),
    );
  }
}

class CursorLocation {
  final int row;
  final int col;

  const CursorLocation({
    required this.row,
    required this.col,
  });

  CursorLocation moveUp(int rows, DocumentMap docMap) {
    final int rowNum = row - rows < 0 ? 0 : row - rows;
    final int rowLen = docMap.chars[rowNum].length;
    final int colNum = col >= rowLen ? rowLen - 1 : col;
    return CursorLocation(row: rowNum, col: colNum);
  }

  CursorLocation moveDown(int rows, DocumentMap docMap) {
    final int docLen = docMap.chars.length;
    final int rowNum = row + rows > docLen ? docLen - 1 : row + rows;
    final int rowLen = docMap.chars[rowNum].length;
    final int colNum = col >= rowLen ? rowLen - 1 : col;
    return CursorLocation(row: rowNum, col: colNum);
  }

  CursorLocation moveLeftBy1(DocumentMap docMap) {
    return col - 1 >= 0
        ? CursorLocation(row: row, col: col - 1)
        : CursorLocation(row: row - 1, col: docMap.chars[row - 1].length - 1);
  }

  CursorLocation moveRightBy1(DocumentMap docMap) {
    return col + 1 <= docMap.chars[row].length
        ? CursorLocation(row: row, col: col + 1)
        : CursorLocation(row: row + 1, col: 0);
  }

  int getRowLocInMap(int mapLength, int expectedRowIndex) {
    if (expectedRowIndex < mapLength) {
      if (0 <= expectedRowIndex) {
        return expectedRowIndex;
      } else {
        return 0;
      }
    } else {
      return mapLength - 1;
    }
  }

  RowColPair getColLocInRow(int rowLength, int expectedColIndex) {
    if (expectedColIndex < rowLength) {
      if (0 <= expectedColIndex) {
        // is within bounds
        return RowColPair(0, expectedColIndex, isResolved: true);
      } else {
        // is in rows above
        return RowColPair(-1, expectedColIndex + 1, isResolved: false);
      }
    } else {
      // is in rows below
      return RowColPair(1, expectedColIndex - 1, isResolved: false);
    }
  }

  /// This action should not be performed directly, but instead called by an
  /// implementation that is [DocumentMap]-aware.
  operator +(CursorLocation other) =>
      CursorLocation(row: row + other.row, col: col + other.col);

  @override
  operator ==(Object other) {
    if (other is! CursorLocation) return false;
    if (other.row == row && other.col == col) return true;
    return false;
  }

  @override
  String toString() => "CL<$row, $col>";
}

class Pair<A, B> {
  final A item1;
  final B item2;

  const Pair(this.item1, this.item2);
}

class RowColPair extends Pair<int, int> {
  final bool isResolved;
  final int row;
  final int col;
  const RowColPair(
    this.row,
    this.col, {
    required this.isResolved,
  }) : super(row, col);
}
