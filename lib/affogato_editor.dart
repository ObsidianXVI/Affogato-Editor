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
  // final Map<EditorInstanceHandle, AffogatoEditorInstance> editorInstances = {};
  final List<EditorInstanceHandle> handles = [];
  final List<AffogatoEditorInstance> instances = [];
  late EditorInstanceHandle activeEditor;
  @override
  void initState() {
    activeEditor = provisionEditorInstance();
    Future.delayed(
      const Duration(seconds: 5),
      () {
        activeEditor = provisionEditorInstance();
        resizeEditorInstances();
        setState(() {});
      },
    );
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
    instances.clear();
    for (final handle in handles) {
      instances.add(spawnEditorInstance(handle));
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
