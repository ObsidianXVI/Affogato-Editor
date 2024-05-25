part of affogato.editor;

class AffogatoEditorInstance extends StatefulWidget {
  final AffogatoEditorConfigs editorConfigs;

  const AffogatoEditorInstance({
    required this.editorConfigs,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => AffogatoEditorInstanceState();
}

class AffogatoEditorInstanceState extends State<AffogatoEditorInstance> {
  late final AffogatoEditorFieldController editorFieldController;
  String oldText = '';

  @override
  void initState() {
    editorFieldController =
        AffogatoEditorFieldController(editorConfigs: widget.editorConfigs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> lineNumberWidgets = [];
    for (int i = 0; i < editorFieldController.text.split('\n').length; i++) {
      lineNumberWidgets.addAll([
        SizedBox(
          height: 20,
          width: 40,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              (i + 1).toString(),
              textAlign: TextAlign.right,
              style: widget.editorConfigs.defaultTextStyle.copyWith(
                color: widget.editorConfigs.defaultTextStyle.color
                    ?.withOpacity(0.4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 0, height: 4),
      ]);
    }
    return Material(
      child: Center(
        child: Container(
          width: widget.editorConfigs.editorWidth,
          height: widget.editorConfigs.editorHeight,
          color: widget.editorConfigs.editorBackgroundColor,
          child: SingleChildScrollView(
            child: SizedBox(
              width: widget.editorConfigs.editorWidth,
              height: widget.editorConfigs.editorHeight,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 10,
                    child: Column(children: lineNumberWidgets),
                  ),
                  Positioned(
                    top: 0,
                    left: 80,
                    width: widget.editorConfigs.editorWidth,
                    height: widget.editorConfigs.editorHeight,
                    child: TextField(
                      autofocus: true,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      onChanged: (newText) => setState(() {
                        final Delta delta;
                        if (newText.isNotEmpty) {
                          final int cursorPos =
                              editorFieldController.selection.start - 1;
                          if (newText.length > oldText.length) {
                            delta = Delta.insertion(
                                char: newText[cursorPos], pos: cursorPos);
                          } else {
                            delta = Delta.deletion(
                                char: newText[cursorPos], pos: cursorPos);
                          }
                        } else {
                          return;
                        }

                        for (final deltaInterceptor
                            in widget.editorConfigs.deltaInterceptors) {
                          deltaInterceptor.handleDelta(
                              delta, editorFieldController);
                        }
                        oldText = newText;
                      }),
                      controller: editorFieldController,
                      cursorColor: widget.editorConfigs.cursorColor,
                      maxLines:
                          1200, // an arbitrarily large number to make TextField occupy full height of parent
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AffogatoEditorConfigs {
  final double editorWidth;
  final double editorHeight;
  final Color editorBackgroundColor;
  final TextStyle defaultTextStyle;
  final Color? cursorColor;
  final List<DeltaInterceptor> deltaInterceptors;

  const AffogatoEditorConfigs({
    required this.editorWidth,
    required this.editorHeight,
    required this.defaultTextStyle,
    this.deltaInterceptors = const [],
    this.editorBackgroundColor = Colors.transparent,
    this.cursorColor,
  });
}
