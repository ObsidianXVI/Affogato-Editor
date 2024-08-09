library affogato.editor;

import 'dart:math';
import 'dart:ui';

import 'package:affogato_core/affogato_core.dart';
import 'package:affogato_editor/battery_langs/generic/language_bundle.dart';
import 'package:affogato_editor/battery_langs/markdown/language_bundle.dart';
import 'package:affogato_editor/battery_themes/affogato_classic/theme_bundle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part './ui/status_bar.dart';
part './ui/primary_bar.dart';
part './ui/editor_file_tab.dart';
part './ui/editor_panel.dart';

part './document_provider/document_provider.dart';

part './affogato_editor_instance.dart';
part './editor_field_controller.dart';
part './delta_interceptor.dart';
part './utils.dart';

typedef EditorInstanceHandle = GlobalKey<AffogatoEditorInstanceState>;
final GlobalKey<AffogatoEditorState> instanceKey = GlobalKey();

class AffogatoEditor extends StatefulWidget {
  final double width;
  final double height;
  final AffogatoEditorConfigs editorConfigs;

  AffogatoEditor({
    required this.width,
    required this.height,
    required this.editorConfigs,
  }) : super(key: instanceKey);

  @override
  State<StatefulWidget> createState() => AffogatoEditorState();
}

class AffogatoEditorState extends State<AffogatoEditor> {
  final List<EditorInstanceHandle> handles = [];
  final List<AffogatoEditorInstance> instances = [];
  final List<AffogatoEditorPanel> editorPanels = [];
  late EditorInstanceHandle activeEditor;
  bool primaryBarExpanded = false;

  @override
  void initState() {
    provisionEditorPanel();
    super.initState();
  }

  void provisionEditorPanel() {
    activeEditor = provisionEditorInstance(
      width: availableEditorsWidth(true),
      height: availableEditorsHeight(),
    );
    editorPanels.add(
      AffogatoEditorPanel(
        width: availableEditorsWidth(true),
        height: availableEditorsHeight(),
        instances: [instances.last],
      ),
    );
    resizeEditorPanels();
    setState(() {});
  }

  void resizeEditorPanels() {
    for (int i = 0; i < editorPanels.length; i++) {
      editorPanels[i] = AffogatoEditorPanel(
        width: availableEditorsWidth(),
        height: availableEditorsHeight(),
        instances: editorPanels[i].instances,
      );
    }
  }

  void removeEditorPanel() {
    editorPanels.removeLast();
    activeEditor = instances.last.handle;
    setState(() {});
  }

  EditorInstanceHandle provisionEditorInstance({
    double? width,
    double? height,
  }) {
    final EditorInstanceHandle handle = GlobalKey();
    handles.add(handle);
    instances.add(
      spawnEditorInstance(
        handle,
        width: width,
        height: height,
      ),
    );

    return handle;
  }

  void deleteEditorInstance(EditorInstanceHandle handle) {
    for (int i = 0; i < handles.length; i++) {
      if (handles[i] == handle) {
        handles.removeAt(i);
        instances.removeAt(i);
        return;
      }
    }
  }

  AffogatoEditorInstance spawnEditorInstance(
    EditorInstanceHandle handle, {
    double? width,
    double? height,
    AffogatoDocumentProvider? documentProvider,
    LanguageBundle? lb,
  }) {
    return AffogatoEditorInstance(
      languageBundle: lb ?? genericLB,
      themeBundle: themeBundle,
      documentProvider: documentProvider ?? EmptyDocumentProvider(),
      width: width ?? availableEditorsWidth(),
      height: height ?? availableEditorsHeight(),
      editorConfigs: AffogatoEditorConfigs(
        defaultTextStyle: widget.editorConfigs.defaultTextStyle,
        deltaInterceptors: widget.editorConfigs.deltaInterceptors,
      ),
      handle: handle,
      setEditorAsActive: (handle) => setState(() {
        activeEditor = handle;
      }),
    );
  }

  void replaceEditorInstance({
    required EditorInstanceHandle oldHandle,
    required EditorInstanceHandle newHandle,
    required AffogatoEditorInstance newInstance,
  }) {
    for (int i = 0; i < handles.length; i++) {
      if (handles[i] == oldHandle) {
        handles[i] = newHandle;
        instances[i] = newInstance;
        return;
      }
    }
  }

  void removeEditorInstance([EditorInstanceHandle? handle]) {
    if (instances.length <= 1) return;
    for (int i = 0; i < handles.length; i++) {
      if (handles[i] == (handle ?? activeEditor)) {
        handles.removeAt(i);
        instances.removeAt(i);
        if (handle == activeEditor) {
          activeEditor = handles[i == 0
              ? i + 1
              : i == handles.length
                  ? i - 1
                  : i];
        }

        break;
      }
    }

    setState(() {});
  }

  /// Set [creatingNewPanel] to true, if a new panel is being created after this method call
  double availableEditorsWidth([
    bool creatingNewPanel = false,
  ]) {
    return (widget.width - (primaryBarExpanded ? 240 : 50)) /
        max(editorPanels.length + (creatingNewPanel ? 1 : 0), 1);
  }

  double availableEditorsHeight() => widget.height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Material(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            SizedBox(
              width: widget.width,
              child: Row(
                children: [
                  PrimaryBar(
                    expanded: primaryBarExpanded,
                    onTap: (expanded) {
                      primaryBarExpanded = !primaryBarExpanded;
                      setState(() {});
                    },
                  ),
                  Row(
                    children: editorPanels,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 20,
              child: StatusBar(
                onLBChanged: (newLB) {
                  final EditorInstanceHandle newHandle = GlobalKey();
                  replaceEditorInstance(
                    oldHandle: activeEditor,
                    newHandle: newHandle,
                    newInstance: spawnEditorInstance(
                      newHandle,
                      documentProvider:
                          activeEditor.currentState!.widget.documentProvider,
                      lb: switch (newLB) {
                        'Markdown' => markdownLB,
                        'Generic' => genericLB,
                        String() => null,
                      },
                    ),
                  );
                  activeEditor = newHandle;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
