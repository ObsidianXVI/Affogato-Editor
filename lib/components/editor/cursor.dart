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

  operator +(CursorLocation other) =>
      CursorLocation(row: row + other.row, col: col + other.col);

  @override
  operator ==(Object other) {
    if (other is! CursorLocation) return false;
    if (other.row == row && other.col == col) return true;
    return false;
  }
}
