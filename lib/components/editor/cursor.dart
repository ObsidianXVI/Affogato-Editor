part of affogato.components;

class Cursor extends StatefulWidget {
  CharCellComponent charCellComponent;
  int currentLine = 0;
  int currentCol = 0;

  Cursor({
    required this.charCellComponent,
    super.key,
  });

  void notifyNewlineInsertion() {
/*     charCellComponent.editorLineState.document.sourceLines.insert(triggerIndex + 1, '');
    cursor.currentLine = triggerIndex + 1;
    cursor.currentCol = 0;
    setState(() {}); */
  }

  void notifyNewlineDeletion() {
/*     widget.document.sourceLines.removeAt(triggerIndex);
    cursor.currentLine = triggerIndex - 1;
    cursor.currentCol = 0;
    setState(() {}); */
  }

  @override
  State<StatefulWidget> createState() => CursorState();
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
      height: 28,
      width: 2,
      curve: Curves.easeIn,
      decoration: BoxDecoration(
        color: color,
      ),
    );
  }
}
