part of affogato.components;

/// An open text editing instance attached to a single [AffogatoDocument], not to be confused with the EditorArea
class AffogatoEditor extends AffogatoComponent {
  final AffogatoDocument document;
  final double width;
  final double height;

  const AffogatoEditor({
    required super.theme,
    required this.width,
    required this.height,
    required this.document,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => EditorState();
}

class EditorState extends State<AffogatoEditor> {
  final List<Widget> lineMarkers = [];
  final List<Widget> editorLines = [];
  late final Cursor cursor = Cursor(
    document: widget.document,
    initialLoc: const CursorLocation(row: 0, col: 0),
  );

  @override
  void initState() {
    lineMarkers
        .addAll(generateLineMarkers(widget.document.documentMap.totalLines));
    for (int row = 0; row < widget.document.documentMap.totalLines; row++) {
      widget.document.documentMap.cells.add(
        List<CharCellComponent>.generate(
          widget.document.documentMap.chars[row].length,
          (int colNo) {
            return CharCellComponent(
              location: CursorLocation(row: row, col: colNo),
              value: widget.document.documentMap.charAt(
                CursorLocation(row: row, col: colNo),
              ),
              editor: this,
              cellStyle: CellStyle(),
            );
          },
        ),
      );
    }

    editorLines
        .addAll(generateEditorLines(widget.document.documentMap.totalLines));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.theme.editorBackground,
      child: Align(
        alignment: Alignment.centerLeft,
        child: KeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          onKeyEvent: (KeyEvent keyEvent) {
            if (keyEvent is KeyUpEvent) {
              if (keyEvent.logicalKey == LogicalKeyboardKey.backspace) {
                print(widget.document.documentMap.charAt(cursor.currentLoc));
              }
            } else if (keyEvent is KeyDownEvent) {
              if (keyEvent.logicalKey == LogicalKeyboardKey.arrowLeft) {
                cursor.cursorLocationNotifier.value =
                    cursor.currentLoc + const CursorLocation(row: 0, col: -1);
              } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowRight) {
                if (keyEvent.logicalKey == LogicalKeyboardKey.arrowRight) {
                  cursor.cursorLocationNotifier.value =
                      cursor.currentLoc + const CursorLocation(row: 0, col: 1);
                }
              }
            }
          },
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70,
                  child: Column(
                    children: lineMarkers,
                  ),
                ),
                const SizedBox(width: 25),
                Expanded(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.text,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: editorLines,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> generateLineMarkers(int lineCount) {
    return List<Widget>.generate(lineCount, (int i) {
      return Center(
        child: Container(
          width: double.infinity,
          height: 28,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: widget.theme.primaryColor.withOpacity(0.3),
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
                    color: widget.theme.primaryColor.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> generateEditorLines(int lineCount) {
    return List<Widget>.generate(lineCount, (int lineNo) {
      return Center(
        child: EditorLineComponent(
          lineNo: lineNo,
          charCells: widget.document.documentMap.cells[lineNo],
          editor: this,
          key: GlobalKey(),
        ),
      );
    });
  }
}
