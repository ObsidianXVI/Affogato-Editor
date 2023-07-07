part of affogato.components;

class EditorLineComponent extends StatefulWidget {
  final int lineNo;
  final String initialContent;
  final EditorState editor;
  final int? cursorPos;

  const EditorLineComponent({
    required this.initialContent,
    required this.editor,
    required this.lineNo,
    required this.cursorPos,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => EditorLineState();
}

class EditorLineState extends State<EditorLineComponent> {
  late final TextEditingController textController;
  String? content;

  @override
  void initState() {
    content = widget.initialContent;
    textController = TextEditingController(
      text: content,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 28,
      child: EditableText(
        controller: textController,
        focusNode: FocusNode(),
        autofocus: widget.cursorPos != null,
        cursorColor: Colors.green,
        backgroundCursorColor: Colors.white,
        onSubmitted: (_) {
          widget.editor.notifyNewlineInsertion(widget.lineNo);
        },
        onChanged: (String value) {
          if (value.isEmpty) widget.editor.notifyNewlineDeletion(widget.lineNo);
        },
        style: const TextStyle(
          fontSize: 18,
          height: 1.4,
          fontFamily: 'DMMono',
          color: Colors.pink,
        ),
      ),

      /**
       * SelectableText.rich(
        TextSpan(
          text: content!,
          style: const TextStyle(
            fontSize: 18,
            height: 1.4,
            fontFamily: 'DMMono',
            color: Colors.pink,
          ),
        ),
        textAlign: TextAlign.start,
      ),
       */
    );
  }
}
