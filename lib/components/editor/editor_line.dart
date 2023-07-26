part of affogato.components;

class EditorLineComponent extends StatefulWidget {
  final int lineNo;
  final EditorState editor;
  final List<CharCellComponent> charCells;

  const EditorLineComponent({
    required this.editor,
    required this.lineNo,
    required this.charCells,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => EditorLineState();
}

class EditorLineState extends State<EditorLineComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.editor.cursor.moveToLocation(widget.charCells.last.location);
      },
      child: Container(
        width: double.infinity,
        height: 28,
        color: Colors.transparent, // need this to detect mouse taps outside
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.charCells,
        ),
      ),
    );
  }
}
