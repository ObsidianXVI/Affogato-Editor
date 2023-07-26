part of affogato.components;

class CharCellComponent extends StatefulWidget {
  final String value;
  final EditorState editor;
  final CellStyle cellStyle;
  final CursorLocation location;

  const CharCellComponent({
    required this.value,
    required this.editor,
    required this.cellStyle,
    required this.location,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => CharCellComponentState();
}

class CharCellComponentState extends State<CharCellComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.editor.cursor.cursorLocationNotifier,
        builder: (BuildContext context, CursorLocation cursorLoc, _) {
          return GestureDetector(
            onTapDown: (_) {
              widget.editor.cursor.cursorLocationNotifier.value =
                  widget.location;
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
                if (cursorLoc == widget.location) widget.editor.cursor,
              ],
            ),
          );
        });
  }
}
