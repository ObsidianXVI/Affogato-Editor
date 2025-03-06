part of affogato.editor;

class AffogatoEditorInstanceData extends PaneInstanceData {
  final String documentId;
  final LanguageBundle? languageBundle;
  final ThemeBundle<dynamic, Color, TextStyle, TextSpan> themeBundle;

  AffogatoEditorInstanceData({
    required this.documentId,
    required this.languageBundle,
    required this.themeBundle,
  });
  @override
  Map<String, Object?> toJson() => {
        'documentId': documentId,
        'languageBundle': languageBundle?.bundleName ?? '',
        'themeBundle':
            themeBundle.editorTheme.toString(), // should be .toJson()
      };
}

class AffogatoEditorInstance extends PaneInstance<AffogatoEditorInstanceData> {
  AffogatoEditorInstance({
    required super.layoutConfigs,
    required super.editorTheme,
    required super.workspaceConfigs,
    required super.extensionsEngine,
    required super.instanceId,
  });

  @override
  AffogatoEditorInstanceState createState() => AffogatoEditorInstanceState();
}

class AffogatoEditorInstanceState
    extends State<PaneInstance<AffogatoEditorInstanceData>>
    with
        utils.StreamSubscriptionManager,
        PaneInstanceStateManager<AffogatoEditorInstanceData>,
        SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  late AffogatoEditorFieldController textController;
  final FocusNode textFieldFocusNode = FocusNode();
  late AffogatoDocument currentDoc;
  late TextStyle codeTextStyle;
  late double cellWidth;
  late double cellHeight;
  bool hasScrolled = false;
  int currentLineNum = 0;
  int currentCharNum = 0;
  int completionItem = 0;
  bool showingCompletions = false;
  final List<String> completions = ['Hello', 'World', 'ABC', '123'];

  late final LocalSearchAndReplaceController searchAndReplaceController =
      LocalSearchAndReplaceController(
    tickerProvider: this,
    onDismiss: () {
      textFieldFocusNode.requestFocus();
      searchAndReplaceController.replaceText = null;
    },
    cellHeight: cellHeight,
    cellWidth: cellWidth,
    textController: textController,
  );

  @override
  void initState() {
    getData();
    scrollController.addListener(() {
      if (scrollController.offset > 0 && !hasScrolled) {
        setState(() {
          hasScrolled = true;
        });
      } else if (scrollController.offset <= 0 && hasScrolled) {
        setState(() {
          hasScrolled = false;
        });
      }
    });

    // All actions needed to spin up a new editor instance
    void loadUpInstance() {
      codeTextStyle = TextStyle(
        color: widget.editorTheme.editorForeground,
        fontFamily: 'IBMPlexMono',
        height: utils.AffogatoConstants.lineHeight,
        fontSize: widget.workspaceConfigs.stylingConfigs.editorFontSize,
      );
      // Create a single Text character using the editor's font style and paint it on an imaginary canvas
      // to observe its width and height. This massively increases performance as font-dependent spacing operations
      // such as generating indentation rulers or calculating cursor position no longer need to build and render multiple
      // Text() objects but rather, can use a predefined SizedBox() and even the calculated cellWidth and cellHeight for computations.
      final tp = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: ' ', style: codeTextStyle),
      )
        ..layout()
        ..paint(
          Canvas(PictureRecorder()),
          Offset.zero,
        );
      cellWidth = (tp.size.width);
      cellHeight = (tp.size.height);
      tp.dispose();

      textController = AffogatoEditorFieldController(
        languageBundle: data.languageBundle,
        themeBundle: data.themeBundle,
        workspaceConfigs: widget.workspaceConfigs,
      )..addListener(() {
          if (textController.text.isNotEmpty) {
            for (int i = textController.selection.baseOffset; i >= 1; i--) {
              if (textController.text[i - 1] == '\n') {
                currentCharNum = textController.selection.baseOffset - i;
                return;
              } else if (i == 1) {
                currentCharNum = textController.selection.baseOffset - i + 1;
                return;
              }
            }
          }
        });

      currentDoc =
          widget.workspaceConfigs.vfs.accessEntity(data.documentId)!.document!;
      // Assume instant autosave
      textController.text = currentDoc.content;

      // Set off the event
      AffogatoEvents.editorInstanceLoadedEvents
          .add(EditorInstanceLoadedEvent(data.documentId));
      widget.workspaceConfigs.activeDocument = data.documentId;

      // Link the text controller to the document
      textController.addListener(() {
        currentDoc.addVersion(textController.text);
        AffogatoEvents.editorDocumentChangedEvents.add(
          EditorDocumentChangedEvent(
            newContent: textController.text,
            documentId: data.documentId,
            selection: textController.selection,
          ),
        );
        setState(() {});
      });

      // the actual document parsing and interceptors
      registerListener(
        AffogatoEvents.editorKeyEvents.stream
            .where((e) => e.instanceId == widget.instanceId),
        (event) {
          if (event.keyEvent is KeyDownEvent) {
            textFieldFocusNode.requestFocus();

            if (event.keyEvent.logicalKey == LogicalKeyboardKey.tab) {
              setState(() {
                insertTextAtCursorPos(' ' *
                    widget.workspaceConfigs.stylingConfigs.tabSizeInSpaces);
              });
            }
          }
        },
      );

      registerListener(
        AffogatoEvents.editorDocumentRequestChangeEvents.stream,
        (event) {
          textController.value = event.editorAction.editingValue;
          setState(() {});

          AffogatoEvents.editorDocumentChangedEvents.add(
            EditorDocumentChangedEvent(
              newContent: textController.text,
              documentId: data.documentId,
              selection: textController.selection,
            ),
          );
        },
      );

      registerListener(
        AffogatoEvents.editorInstanceRequestToggleSearchOverlayEvents.stream
            .where((event) => event.documentId == data.documentId),
        (_) => setState(() {
          searchAndReplaceController.toggle();
        }),
      );
    }

    // Call once during initState
    loadUpInstance();

    // And register a listener to call whenever the instance needs to be reloaded
    registerListener(
      AffogatoEvents.editorInstanceRequestReloadEvents.stream,
      (event) {
        setState(() {
          // `saveInstance()`
          loadUpInstance();
        });
      },
    );

    super.initState();
  }

  void insertTextAtCursorPos(String text, {bool moveCursorToEnd = true}) {
    if (textController.selection.isValid) {
      textController.value = TextEditingValue(
        text: textController.selection.isCollapsed
            ? textController.text.substring(0, textController.selection.start) +
                text +
                textController.text.substring(
                    textController.selection.end, textController.text.length)
            : textController.text.replaceRange(
                textController.selection.start,
                textController.selection.end,
                text,
              ),
        selection: moveCursorToEnd
            ? TextSelection.collapsed(
                offset: textController.selection.start + 4)
            : textController.selection,
      );
    }
  }

  List<Row> generateIndentationRulers() {
    final List<Row> rows = [];
    // this flag allows a single indentation ruler to be added to the
    // start of lines inside a nested code snippet, such as a function body, even
    // if they are empty lines
    bool isNested = false;
    for (final line in textController.text.split('\n')) {
      // create an initial Row
      final List<Widget> rowItems = [Text('', style: codeTextStyle)];
      // only trigger the loop if there is a possbility of indentation
      if (line.startsWith(' ')) {
        isNested = true;
        for (int i = 0; i < line.length; i++) {
          if (line[i] == ' ') {
            // add an indentation ruler at every tab
            if (i % widget.workspaceConfigs.stylingConfigs.tabSizeInSpaces ==
                0) {
              rowItems.add(
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 0.5,
                        color:
                            widget.editorTheme.editorIndentGuideBackground1 ??
                                Colors.red,
                      ),
                    ),
                  ),
                  child: SizedBox(
                      width: cellWidth *
                          widget
                              .workspaceConfigs.stylingConfigs.tabSizeInSpaces,
                      height: cellHeight),
                ),
              );
            }
          } else {
            break;
          }
        }
      } else {
        isNested = false;
      }
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: line.trim() == '' && !isNested
              ? [
                  SizedBox(
                    width: 0,
                    height: cellHeight,
                  )
                ]
              : rowItems,
        ),
      );
    }

    return rows;
  }

  List<Widget> generateLineNumbers() {
    final List<Widget> lineNumbers = [];
    final int activeLineNum = textController.text
        .substring(0, textController.selection.end)
        .split('\n')
        .length;
    currentLineNum = activeLineNum;
    for (int i = 1; i <= textController.text.split('\n').length; i++) {
      lineNumbers.add(
        SizedBox(
          width: utils.AffogatoConstants.lineNumbersColWidth,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              i.toString(),
              textAlign: TextAlign.right,
              style: codeTextStyle.copyWith(
                color: i == activeLineNum
                    ? widget.editorTheme.editorLineNumberActiveForeground
                    : widget.editorTheme.editorLineNumberForeground,
              ),
            ),
          ),
        ),
      );

      /* leftGutterIndicators.add(
        Padding(
          padding: const EdgeInsets.only(
              right: utils.AffogatoConstants.lineNumbersGutterRightmostPadding),
          child: Container(
            width: utils.AffogatoConstants.lineNumbersGutterWidth -
                utils.AffogatoConstants.lineNumbersGutterRightmostPadding,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: widget.editorTheme.defaultTextColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Text(
              '',
              textAlign: TextAlign.right,
              style: TextStyle(
                height: utils.AffogatoConstants.lineHeight,
                fontSize: widget.stylingConfigs.editorFontSize,
              ),
            ),
          ),
        ),
      ); */
    }
    return lineNumbers;
  }

  /// Generates the Git diff indicators and code folding buttons.
  List<Widget> generateLeftGutterWidgets() {
    const List<Widget> results = [];

    return results;
  }

  void acceptAndDismissCompletionsWidget() {
    final String textBefore =
        textController.selection.textBefore(textController.text);
    textController.value = TextEditingValue(
      text: textBefore +
          completions[completionItem] +
          textController.selection.textAfter(textController.text),
      selection: TextSelection.collapsed(
        offset: (textBefore + completions[completionItem]).length,
      ),
    );
    AffogatoEvents.editorDocumentChangedEvents.add(
      EditorDocumentChangedEvent(
        newContent: textController.text,
        documentId: data.documentId,
        selection: textController.selection,
      ),
    );
    setState(() {
      showingCompletions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          // Editing Area
          Positioned(
            top: utils.AffogatoConstants.breadcrumbHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              controller: scrollController,
              hitTestBehavior: HitTestBehavior.translucent,
              child: Stack(
                children: [
                  // Decorations Area — for decorations below the editing layer
                  ...searchAndReplaceController.searchAndReplaceMatchHighlights,
                  Positioned(
                    left: utils.AffogatoConstants.lineNumbersColWidth +
                        utils.AffogatoConstants.lineNumbersGutterWidth,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: generateIndentationRulers(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Line numbers
                      SizedBox(
                        width: utils.AffogatoConstants.lineNumbersColWidth,
                        child: Column(
                          children: [
                            ...generateLineNumbers(),
                            const SizedBox(
                                height:
                                    utils.AffogatoConstants.overscrollAmount),
                          ],
                        ),
                      ),
                      // Left gutter indicators, such as for Git
                      SizedBox(
                        width: utils.AffogatoConstants.lineNumbersGutterWidth -
                            utils.AffogatoConstants
                                .lineNumbersGutterRightmostPadding,
                        child: Column(
                          children: generateLeftGutterWidgets(),
                        ),
                      ),
                      // Editing Field
                      Expanded(
                        child: Focus(
                          onKeyEvent: (_, key) {
                            if (searchAndReplaceController.isShown) {
                              searchAndReplaceController.dismiss();
                            }
                            if (showingCompletions && key is KeyDownEvent) {
                              if (key.logicalKey ==
                                  LogicalKeyboardKey.arrowUp) {
                                if (completionItem != 0) {
                                  completionItem -= 1;
                                }
                                setState(() {});
                                return KeyEventResult.handled;
                              } else if (key.logicalKey ==
                                  LogicalKeyboardKey.arrowDown) {
                                if (completionItem != completions.length - 1) {
                                  completionItem += 1;
                                }
                                setState(() {});
                                return KeyEventResult.handled;
                              } else if (key.logicalKey ==
                                  LogicalKeyboardKey.escape) {
                                setState(() {
                                  showingCompletions = false;
                                });

                                return KeyEventResult.handled;
                              } else if (key.logicalKey ==
                                  LogicalKeyboardKey.enter) {
                                acceptAndDismissCompletionsWidget();
                                return KeyEventResult.handled;
                              }
                            }
                            final EditorKeyEvent keyEvent = EditorKeyEvent(
                              instanceId: widget.instanceId,
                              keyEvent: key,
                              editingContext: EditingContext(
                                content: widget.workspaceConfigs.vfs
                                    .accessEntity(data.documentId,
                                        isDir: false)!
                                    .document!
                                    .content,
                                selection: textController.selection,
                              ),
                            );

                            AffogatoEvents.editorKeyEvents.add(keyEvent);

                            return widget.extensionsEngine
                                .triggerEditorKeybindings(keyEvent);
                          },
                          child: Theme(
                            data: ThemeData(
                              textSelectionTheme: TextSelectionThemeData(
                                cursorColor:
                                    widget.editorTheme.editorForeground,
                                selectionColor: widget.editorTheme
                                        .editorSelectionHighlightBackground ??
                                    Colors.red,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  selectionControls:
                                      EmptyTextSelectionControls(),
                                  readOnly: currentDoc.readOnly,
                                  focusNode: textFieldFocusNode,
                                  maxLines: null,
                                  controller: textController,
                                  decoration: null,
                                  style: codeTextStyle.copyWith(
                                      color: widget
                                          .editorTheme.textPreformatForeground),
                                ),
                                MouseRegion(
                                  opaque: false,
                                  hitTestBehavior: HitTestBehavior.translucent,
                                  cursor: SystemMouseCursors.text,
                                  child: GestureDetector(
                                    onTapUp: (_) {
                                      textController.selection =
                                          TextSelection.fromPosition(
                                        TextPosition(
                                            offset: textController.text.length),
                                      );
                                      textFieldFocusNode.requestFocus();
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      width: double.infinity,
                                      height: utils
                                          .AffogatoConstants.overscrollAmount,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Overlays Area (hover suggestions, completions UI)
          if (scrollController.hasClients && showingCompletions)
            Positioned(
              top: utils.AffogatoConstants.breadcrumbHeight +
                  textController.text
                          .substring(0, textController.selection.baseOffset)
                          .split('\n')
                          .length *
                      cellHeight -
                  scrollController.offset,
              left: utils.AffogatoConstants.lineNumbersColWidth +
                  utils.AffogatoConstants.lineNumbersGutterWidth +
                  currentCharNum * cellWidth,
              width: utils.AffogatoConstants.completionsMenuWidth,
              child: AffogatoCompletionsWidget(
                completions: completions,
                editorTheme: widget.editorTheme,
                currentSelection: completionItem,
                onSelectionIndexChange: (newIndex) =>
                    setState(() => completionItem = newIndex),
                onSelectionAccept: () => setState(() {
                  acceptAndDismissCompletionsWidget();
                  textFieldFocusNode.requestFocus();
                }),
              ),
            ),
          // Search-and-replace overlays
          Positioned(
            top: utils.AffogatoConstants.breadcrumbHeight,
            right: utils.AffogatoConstants.breadcrumbHeight + 5,
            child: SlideTransition(
              position:
                  searchAndReplaceController.searchAndReplaceOffsetAnimation,
              child: SearchAndReplaceWidget(
                key: searchAndReplaceController.overlayKey,
                width: utils.AffogatoConstants.searchAndReplaceWidgetWidth,
                textStyle: codeTextStyle,
                editorTheme: widget.editorTheme,
                onSearchTextChanged: (newText) {
                  searchAndReplaceController.regenerateMatches(
                      newText: newText);
                  setState(() {});
                },
                onReplaceTextChanged: (newText) {
                  searchAndReplaceController.replaceText = newText;
                },
                searchActionItems: [
                  Text(
                    "${searchAndReplaceController.searchItemCurrentIndex} of ${searchAndReplaceController.matches.length}",
                    style: widget.editorTheme.defaultTextStyle.copyWith(
                      color: widget.editorTheme.buttonSecondaryForeground,
                    ),
                  ),
                  const SizedBox(width: 16),
                  AffogatoButton(
                    width:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    height:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    editorTheme: widget.editorTheme,
                    isPrimary: false,
                    onTap: () => setState(() {
                      searchAndReplaceController
                        ..prevMatch()
                        ..scrollIfActiveMatchOutsideViewport(
                          scrollOffset: scrollController.offset,
                          viewportHeight: constraints.maxHeight -
                              utils.AffogatoConstants.breadcrumbHeight,
                          scrollCallback: scrollController.jumpTo,
                        );
                    }),
                    child: Icon(
                      Icons.arrow_upward,
                      size: utils
                              .AffogatoConstants.searchAndReplaceRowItemHeight -
                          10,
                      color: widget.editorTheme.buttonSecondaryForeground,
                    ),
                  ),
                  const SizedBox(width: 16),
                  AffogatoButton(
                    width:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    height:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    editorTheme: widget.editorTheme,
                    isPrimary: false,
                    onTap: () => setState(() {
                      searchAndReplaceController
                        ..nextMatch()
                        ..scrollIfActiveMatchOutsideViewport(
                          scrollOffset: scrollController.offset,
                          viewportHeight: constraints.maxHeight -
                              utils.AffogatoConstants.breadcrumbHeight,
                          scrollCallback: scrollController.jumpTo,
                        );
                    }),
                    child: Icon(
                      Icons.arrow_downward,
                      size: utils
                              .AffogatoConstants.searchAndReplaceRowItemHeight -
                          10,
                      color: widget.editorTheme.buttonSecondaryForeground,
                    ),
                  ),
                  const SizedBox(width: 16),
                  AffogatoButton(
                    width:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    height:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    editorTheme: widget.editorTheme,
                    isPrimary: false,
                    onTap: () {
                      searchAndReplaceController.dismiss();
                      textFieldFocusNode.requestFocus();
                    },
                    child: Icon(
                      Icons.close,
                      size: utils
                              .AffogatoConstants.searchAndReplaceRowItemHeight -
                          10,
                      color: widget.editorTheme.buttonSecondaryForeground,
                    ),
                  )
                ],
                replaceActionItems: [
                  AffogatoButton(
                    width:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    height:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    editorTheme: widget.editorTheme,
                    isPrimary: false,
                    onTap: () => setState(() {
                      searchAndReplaceController.replaceCurrentMatch();
                    }),
                    child: Icon(
                      Icons.keyboard_return,
                      size: utils
                              .AffogatoConstants.searchAndReplaceRowItemHeight -
                          10,
                      color: widget.editorTheme.buttonSecondaryForeground,
                    ),
                  ),
                  const SizedBox(width: 16),
                  AffogatoButton(
                    width:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    height:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    editorTheme: widget.editorTheme,
                    isPrimary: false,
                    onTap: () => setState(() {
                      searchAndReplaceController.replaceAllMatches();
                    }),
                    child: Icon(
                      Icons.restore_page,
                      size: utils
                              .AffogatoConstants.searchAndReplaceRowItemHeight -
                          10,
                      color: widget.editorTheme.buttonSecondaryForeground,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Breadcrumb Widget
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: utils.AffogatoConstants.breadcrumbHeight,
            child: Container(
              width: double.infinity,
              height: utils.AffogatoConstants.breadcrumbHeight,
              decoration: BoxDecoration(
                color: widget
                    .workspaceConfigs.themeBundle.editorTheme.editorBackground,
                boxShadow: hasScrolled
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : const [],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.workspaceConfigs.vfs.pathToEntity(data.documentId) ??
                        'Unsaved',
                    style: widget.editorTheme.defaultTextStyle.copyWith(
                        fontSize: widget.workspaceConfigs.stylingConfigs
                                .editorFontSize -
                            3),
                  ),
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
    searchAndReplaceController.searchAndReplaceAnimationController.dispose();
    textController.dispose();
    cancelSubscriptions();
    super.dispose();
  }
}
