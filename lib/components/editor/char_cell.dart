part of affogato.components;

const double charCellWidth = 11;
const double halfWidth = charCellWidth / 2;

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
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          cursorPosLeft = details.localPosition.dx < halfWidth;
          widget.editor.cursor.cursorLocationNotifier.value = cursorPosLeft
              ? widget.location.moveLeftBy1(
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
        ],
      ),
    );
  }
}
