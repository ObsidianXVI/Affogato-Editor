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
part './ui/left_bar.dart';

part './affogato_editor_instance.dart';
part './editor_field_controller.dart';
part './delta_interceptor.dart';
part './utils.dart';

typedef EditorInstanceHandle = GlobalKey<AffogatoEditorInstanceState>;
final GlobalKey<AffogatoEditorState> instanceKey = GlobalKey();

class AffogatoEditor extends StatefulWidget {
  final AffogatoEditorConfigs editorConfigs;

  AffogatoEditor({
    required this.editorConfigs,
  }) : super(key: instanceKey);

  @override
  State<StatefulWidget> createState() => AffogatoEditorState();
}

class AffogatoEditorState extends State<AffogatoEditor> {
  // final Map<EditorInstanceHandle, AffogatoEditorInstance> editorInstances = {};
  final List<EditorInstanceHandle> handles = [];
  final List<AffogatoEditorInstance> instances = [];
  late EditorInstanceHandle activeEditor;
  @override
  void initState() {
    activeEditor = provisionEditorInstance();
    super.initState();
  }

  EditorInstanceHandle provisionEditorInstance() {
    final EditorInstanceHandle handle = GlobalKey();
    handles.add(handle);
    instances.add(spawnEditorInstance(handle));

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
    LanguageBundle? lb,
    String? content,
  }) =>
      AffogatoEditorInstance(
        languageBundle: lb ?? genericLB,
        themeBundle: themeBundle,
        content: content,
        editorConfigs: AffogatoEditorConfigs(
          editorWidth:
              widget.editorConfigs.editorWidth / max(handles.length, 1),
          editorHeight: widget.editorConfigs.editorHeight,
          defaultTextStyle: widget.editorConfigs.defaultTextStyle,
          deltaInterceptors: widget.editorConfigs.deltaInterceptors,
        ),
        handle: handle,
        setEditorAsActive: (handle) => setState(() {
          activeEditor = handle;
        }),
      );

  void resizeEditorInstances() {
    for (final handle in handles) {
      if (handle.currentState == null) continue;
      handle.currentState!
        ..width = widget.editorConfigs.editorWidth / max(handles.length, 1)
        ..setState(() {});
    }
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

  void addEditorInstance() {
    activeEditor = provisionEditorInstance();
    resizeEditorInstances();
    setState(() {});
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
    resizeEditorInstances();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.editorConfigs.editorWidth,
      height: widget.editorConfigs.editorHeight,
      child: Material(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            SizedBox(
              width: widget.editorConfigs.editorWidth,
              child: Row(
                children: instances,
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
                      content:
                          activeEditor.currentState!.editorFieldController.text,
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
