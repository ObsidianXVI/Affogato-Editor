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
  bool cursorPosLeft = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.editor.cursor.cursorLocationNotifier,
        builder: (BuildContext context, CursorLocation cursorLocation, _) {
          final bool willRenderCursor = cursorLocation == widget.location;
          return GestureDetector(
            onTapDown: (TapDownDetails details) {
              setState(() {
                final double halfWidth =
                    (context.findRenderObject() as RenderBox).size.width / 2;
                cursorPosLeft = details.localPosition.dx < halfWidth;
                widget.editor.cursor.cursorLocationNotifier.value =
                    cursorPosLeft
                        ? widget.location.moveBy(
                            const CursorLocation(row: 0, col: -1),
                            widget.editor.widget.document.documentMap,
                          )
                        : widget.location;
              });
            },
            child: Stack(
              alignment: AlignmentDirectional.centerEnd,
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
                if (willRenderCursor) widget.editor.cursor,
              ],
            ),
          );
        });
  }
}
