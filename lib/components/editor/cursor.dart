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

  void moveToLocation(CursorLocation location,
      {bool forceCursorRight = false}) {
    cursorLocationNotifier.value = location;
  }
}

class CursorState extends State<Cursor> {
  late final Timer timer;
  Color color = Colors.green;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      color = color == Colors.green ? Colors.transparent : Colors.green;
      setState(() {});
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

  CursorLocation moveBy(CursorLocation steps, DocumentMap documentMap) {
    final int finalRowNum =
        getRowLocInMap(documentMap.chars.length, row + steps.row);
    final int rowLength = documentMap.chars[finalRowNum].length;
    final int finalColNum = getColLocInRow(rowLength, col + steps.col);
    return CursorLocation(row: finalRowNum, col: finalColNum);
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

  int getColLocInRow(int rowLength, int expectedColIndex) {
    if (expectedColIndex < rowLength) {
      if (0 <= expectedColIndex) {
        return expectedColIndex;
      } else {
        return 0;
      }
    } else {
      return rowLength - 1;
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
