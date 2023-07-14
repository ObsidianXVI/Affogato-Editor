part of affogato.components;

class Cursor extends StatefulWidget {
  const Cursor({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => CursorState();
}

class CursorState extends State<Cursor> {
  int lineNo = 0;
  int colNo = 0;
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
      height: 28,
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
