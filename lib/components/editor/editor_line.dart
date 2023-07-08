part of affogato.components;

class EditorLineComponent extends StatefulWidget {
  final int lineNo;
  final String initialContent;
  final EditorState editor;

  const EditorLineComponent({
    required this.initialContent,
    required this.editor,
    required this.lineNo,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => EditorLineState();
}

class EditorLineState extends State<EditorLineComponent> {
  String? content;

  @override
  void initState() {
    content = widget.initialContent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<CharCellComponent> charCells = [
      for (String char in content!.split(''))
        CharCellComponent(
          value: char,
          editorLineState: this,
          key: GlobalKey(),
        ),
    ];
    return GestureDetector(
      onTap: () {
        ((charCells.last.key as GlobalKey).currentState
                as CharCellComponentState)
            .spawnCursor();
      },
      child: Container(
        width: double.infinity,
        height: 28,
        color: Colors.transparent, // need this to detect mouse taps outside
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: charCells,
        ),
      ),
    );
  }
}
