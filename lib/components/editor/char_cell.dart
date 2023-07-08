part of affogato.components;

class CharCellComponent extends StatefulWidget {
  final String value;
  final EditorLineState editorLineState;
  final Cursor? initialCursor;
  final CellStyle cellStyle;

  const CharCellComponent({
    required this.value,
    required this.editorLineState,
    required this.cellStyle,
    this.initialCursor,
    super.key,
  });
  @override
  State<StatefulWidget> createState() => CharCellComponentState();
}

class CharCellComponentState extends State<CharCellComponent> {
  Cursor? cursor;

  @override
  void initState() {
    cursor = widget.initialCursor;
    Events.cursor.registerListenerFor<SpawnCursorReplacementCallback>(
      Events.cursor.spawnCursorReplacement,
      () {
        if (cursor != null) {
          cursor = null;
          widget.editorLineState.setState(() {});
        }
      },
    );
    super.initState();
  }

  void spawnCursor() {
    Events.cursor.spawnCursorReplacement();
    cursor = Cursor(
      charCellComponent: widget,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        spawnCursor();
      },
      child: Stack(
        children: [
          Text(
            widget.value,
            style: const TextStyle(
              fontSize: 18,
              height: 1.4,
              fontFamily: 'DMMono',
              color: Colors.pink,
            ),
          ),
          if (cursor != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: cursor!,
            ),
        ],
      ),
    );
  }
}
