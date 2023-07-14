part of affogato.components;

/// An open text editing instance attached to a single [AffogatoDocument], not to be confused with the EditorArea
class AffogatoEditor extends AffogatoComponent {
  final AffogatoDocument document;
  final double width;
  final double height;
  final List<EditorLineComponent> editorLines = [];
  final Cursor cursor = const Cursor();

  AffogatoEditor({
    required super.theme,
    required this.width,
    required this.height,
    required this.document,
  });

  @override
  State<StatefulWidget> createState() => EditorState();
}

class EditorState extends State<AffogatoEditor> {
  @override
  void initState() {
    for (int row = 0; row < widget.document.documentMap.totalLines; row++) {
      widget.document.documentMap.cells.add(
        List<CharCellComponent>.generate(
          widget.document.documentMap.chars[row].length,
          (int colNo) {
            return CharCellComponent(
              value: widget.document.documentMap.charAt(
                CursorLocation(row: row, col: colNo),
              ),
              editor: this,
              cellStyle: CellStyle(),
              key: GlobalKey(),
            );
          },
        ),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int lineCount = widget.document.documentMap.totalLines;
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
                    children: List<Widget>.generate(lineCount, (int lineNo) {
                      return Center(
                        child: EditorLineComponent(
                          lineNo: lineNo,
                          charCells: widget.document.documentMap.cells[lineNo],
                          editor: this,
                          key: GlobalKey(),
                        ),
                      );
                    }),
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
