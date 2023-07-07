part of affogato.components;

class EditorComponent extends AffogatoComponent {
  final AffogatoDocument document;
  final double width;
  final double height;
  final List<EditorLineComponent> editorLines = [];

  EditorComponent({
    required super.theme,
    required this.width,
    required this.height,
    required this.document,
  });

  @override
  State<StatefulWidget> createState() => EditorState();
}

class EditorState extends State<EditorComponent> {
  final Cursor cursor = Cursor();

  void notifyNewlineInsertion(int triggerIndex) {
    widget.document.sourceLines.insert(triggerIndex + 1, '');
    cursor.currentLine = triggerIndex + 1;
    cursor.currentCol = 0;
    setState(() {});
  }

  void notifyNewlineDeletion(int triggerIndex) {
    widget.document.sourceLines.removeAt(triggerIndex);
    cursor.currentLine = triggerIndex - 1;
    cursor.currentCol = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final int lineCount = widget.document.sourceLines.length;
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.theme.editorBackground,
      child: Align(
        alignment: Alignment.centerLeft,
        child: MouseRegion(
          cursor: SystemMouseCursors.text,
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70,
                  child: Column(
                    children: [
                      ...List<Widget>.generate(lineCount, (int i) {
                        return Center(
                          child: Container(
                            width: double.infinity,
                            height: 28,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: widget.theme.primaryColor
                                      .withOpacity(0.3),
                                ),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 2,
                                  right: 25,
                                  child: Text(
                                    i.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      height: 1.4,
                                      fontFamily: 'DMMono',
                                      color: widget.theme.primaryColor
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(width: 25),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List<Widget>.generate(lineCount, (int i) {
                        return Center(
                          child: EditorLineComponent(
                            lineNo: i,
                            initialContent: widget.document.sourceLines[i],
                            cursorPos: i == cursor.currentLine
                                ? cursor.currentCol
                                : null,
                            editor: this,
                            key: GlobalKey(),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
