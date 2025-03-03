part of affogato.editor;

class EditorPane extends StatefulWidget {
  final List<String> documentIds;
  final LayoutConfigs layoutConfigs;
  final AffogatoStylingConfigs stylingConfigs;
  final AffogatoPerformanceConfigs performanceConfigs;
  final AffogatoWorkspaceConfigs workspaceConfigs;
  final AffogatoExtensionsEngine extensionsEngine;
  final GlobalKey<AffogatoWindowState> windowKey;

  final String paneId;

  const EditorPane({
    required this.stylingConfigs,
    required this.layoutConfigs,
    required this.performanceConfigs,
    required this.workspaceConfigs,
    required this.extensionsEngine,
    required this.documentIds,
    required this.windowKey,
    required this.paneId,
    required super.key,
  });

  @override
  State<StatefulWidget> createState() => EditorPaneState();
}

class EditorPaneState extends State<EditorPane>
    with utils.StreamSubscriptionManager {
  String? currentDocumentId;
  LanguageBundle? currentLB;

  @override
  void initState() {
    if (!widget.workspaceConfigs.paneDocumentData.containsKey(widget.paneId)) {
      widget.workspaceConfigs.paneDocumentData[widget.paneId] =
          widget.documentIds;
    }

    registerListener(
      AffogatoEvents.editorInstanceSetActiveEvents.stream
          .where((e) => e.paneId == widget.paneId),
      (event) {
        setState(() {
          currentDocumentId = event.documentId;
          currentLB = event.languageBundle;
          AffogatoEvents.editorInstanceRequestReloadEvents
              .add(const EditorInstanceRequestReloadEvent());
        });
      },
    );

    registerListener(
      AffogatoEvents.windowEditorInstanceUnsetActiveEvents.stream
          .where((e) => e.paneId == widget.paneId),
      (event) {
        setState(() {
          if (widget.documentIds.isEmpty) {
            currentDocumentId = null;
            currentLB = null;
          } else {
            currentDocumentId = widget.documentIds.last;
            currentLB = widget.workspaceConfigs.detectLanguage(widget
                .workspaceConfigs.vfs
                .accessEntity(widget.documentIds.last)!
                .document!
                .extension);
          }
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AffogatoInstanceState? instanceState;
    if (widget.performanceConfigs.rendererType ==
        InstanceRendererType.savedState) {
      if (widget.workspaceConfigs.statesRegistry
          .containsKey(currentDocumentId)) {
        instanceState =
            widget.workspaceConfigs.statesRegistry[currentDocumentId!];
      } else {
        widget.workspaceConfigs.statesRegistry[currentDocumentId!] =
            instanceState = AffogatoInstanceState(
          cursorPos: 0,
          scrollHeight: 0,
          languageBundle: currentLB,
        );
      }
    }
    return Expanded(
      child: Column(
        children: [
          if (widget.documentIds.isNotEmpty)
            FileTabBar(
              stylingConfigs: widget.stylingConfigs,
              documentIds:
                  widget.workspaceConfigs.paneDocumentData[widget.paneId]!,
              workspaceConfigs: widget.workspaceConfigs,
              currentDocId: currentDocumentId,
              paneId: widget.paneId,
            ),
          currentDocumentId != null
              ? Container(
                  width: double.infinity,
                  height: widget.layoutConfigs.height -
                      widget.stylingConfigs.tabBarHeight -
                      utils.AffogatoConstants.tabBarPadding * 2,
                  decoration: BoxDecoration(
                    color: widget.workspaceConfigs.themeBundle.editorTheme
                        .editorBackground,
                    border: Border(
                      left: BorderSide(
                        color: widget.workspaceConfigs.themeBundle.editorTheme
                                .panelBorder ??
                            Colors.red,
                      ),
                      right: BorderSide(
                        color: widget.workspaceConfigs.themeBundle.editorTheme
                                .panelBorder ??
                            Colors.red,
                      ),
                      bottom: BorderSide(
                        color: widget.workspaceConfigs.themeBundle.editorTheme
                                .panelBorder ??
                            Colors.red,
                      ),
                    ),
                  ),
                  child: AffogatoEditorInstance(
                    documentId: currentDocumentId!,
                    workspaceConfigs: widget.workspaceConfigs,
                    width: widget.layoutConfigs.width,
                    editorTheme:
                        widget.workspaceConfigs.themeBundle.editorTheme,
                    instanceState: instanceState,
                    extensionsEngine: widget.extensionsEngine,
                    languageBundle: instanceState?.languageBundle ?? currentLB,
                    themeBundle: widget.workspaceConfigs.themeBundle,
                  ),
                )
              : Center(
                  child: SizedBox(
                    width: 100,
                    height: 50,
                    child: Text(
                      'Affogato',
                      style: TextStyle(
                        color: widget.workspaceConfigs.themeBundle.editorTheme
                            .editorForeground,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  void dispose() async {
    cancelSubscriptions();
    super.dispose();
  }
}
