part of affogato.editor;

const TextStyle editorDefaultStyle = TextStyle(
  fontFamily: 'IBMPlexMono',
);

class AffogatoEditorInstance<T extends AffogatoRenderToken,
    H extends SyntaxHighlighter<T>> extends StatefulWidget {
  final LanguageBundle languageBundle;
  final ThemeBundle<T, H> themeBundle;
  final double width;
  final double height;
  final AffogatoEditorConfigs editorConfigs;
  final void Function(EditorInstanceHandle) setEditorAsActive;
  final EditorInstanceHandle handle;
  final AffogatoDocumentProvider documentProvider;

  const AffogatoEditorInstance({
    required this.width,
    required this.height,
    required this.editorConfigs,
    required this.languageBundle,
    required this.themeBundle,
    required this.setEditorAsActive,
    required this.documentProvider,
    required this.handle,
  }) : super(key: handle);

  @override
  State<StatefulWidget> createState() => AffogatoEditorInstanceState();
}

class AffogatoEditorInstanceState extends State<AffogatoEditorInstance> {
  late final AffogatoEditorFieldController editorFieldController;
  final FocusNode editorFieldFocusNode = FocusNode();

  @override
  void initState() {
    editorFieldController = AffogatoEditorFieldController(
      editorConfigs: widget.editorConfigs,
      languageBundle: widget.languageBundle,
      themeBundle: widget.themeBundle,
      content: widget.documentProvider.getContents(),
    );
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
                fontFamily: editorDefaultStyle.fontFamily,
                color: widget.editorConfigs.defaultTextStyle.color
                    ?.withOpacity(0.4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 0, height: 4),
      ]);
    }
    final AffogatoEditorPanelData panelData =
        AffogatoEditorPanelData.of(context);
    return Material(
      child: Focus(
        onFocusChange: (hasFocus) {
          hasFocus ? widget.setEditorAsActive(widget.handle) : null;
        },
        child: Center(
          child: Container(
            width: panelData.width,
            height: panelData.height,
            decoration: BoxDecoration(
              color: widget.editorConfigs.editorBackgroundColor,
              border: const Border(
                left: BorderSide(color: afLightBrown3),
                right: BorderSide(color: afLightBrown3),
              ),
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                width: panelData.width,
                height: panelData.height,
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
                      width: panelData.width,
                      height: panelData.height,
                      child: KeyboardListener(
                        focusNode: editorFieldFocusNode,
                        onKeyEvent: (event) {
                          if (event is KeyDownEvent) {
                            if (event.logicalKey == LogicalKeyboardKey.tab) {
                              editorFieldController.text =
                                  editorFieldController.text.insert(
                                      editorFieldController.selection.start,
                                      '    ');
                              setState(() {});
                            }
                          }
                        },
                        child: TextField(
                          autocorrect: false,
                          onChanged: (_) => setState(() {}),
                          selectionHeightStyle: BoxHeightStyle.max,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(0),
                          ),
                          controller: editorFieldController,
                          cursorColor: widget.editorConfigs.cursorColor,
                          maxLines:
                              1200, // an arbitrarily large number to make TextField occupy full height of parent
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    editorFieldController.dispose();
    super.dispose();
  }
}

class AffogatoEditorConfigs {
  final Color backgroundColor;
  final Color editorBackgroundColor;
  final TextStyle defaultTextStyle;
  final Color cursorColor;
  final List<DeltaInterceptor> deltaInterceptors;

  const AffogatoEditorConfigs({
    required this.defaultTextStyle,
    this.deltaInterceptors = const [],
    this.editorBackgroundColor = afBrown,
    this.backgroundColor = afLightBrown3,
    this.cursorColor = afCream,
  });
}
