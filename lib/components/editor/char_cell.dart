part of affogato.components;

class CharCellComponent extends StatefulWidget {
  final String value;
  final EditorState editor;
  final CellStyle cellStyle;
  final CursorLocation location;
  final GlobalKey<CharCellComponentState> globalKey = GlobalKey();

  CharCellComponent({
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
    return GestureDetector(
      onTapDown: (_) {
        widget.editor.cursor.moveToCell(this);
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
          if (widget.editor.cursor.cursorLocation == widget.location)
            widget.editor.cursor,
        ],
      ),
    );
  }
}
