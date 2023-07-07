part of affogato.components;

class CharCellComponent extends StatefulWidget {
  final String value;
  final EditorLineState editorLineState;
  final Cursor? initialCursor;

  const CharCellComponent({
    required this.value,
    required this.editorLineState,
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
          print('removing cursor');
          cursor = null;
          widget.editorLineState.setState(() {});
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Events.cursor.spawnCursorReplacement();
        cursor = Cursor();

        print('spawing replacement');
        setState(() {});
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
