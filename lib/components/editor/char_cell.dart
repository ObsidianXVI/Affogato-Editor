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
        builder: (BuildContext context, CursorConfigs cursorConfigs, _) {
          final bool willRenderCursor =
              cursorConfigs.location == widget.location;
          return GestureDetector(
            onTapDown: (TapDownDetails details) {
              setState(() {
                final double halfWidth =
                    (context.findRenderObject() as RenderBox).size.width / 2;
                cursorPosLeft = details.localPosition.dx < halfWidth;
                widget.editor.cursor.cursorLocationNotifier.value =
                    CursorConfigs(
                  location: widget.location,
                  forceCursorRight: false,
                );
              });
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
                if (willRenderCursor)
                  Positioned(
                    left: !cursorConfigs.forceCursorRight && cursorPosLeft
                        ? 0
                        : 8,
                    bottom: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: widget.editor.cursor,
                    ),
                  ),
              ],
            ),
          );
        });
  }
}
