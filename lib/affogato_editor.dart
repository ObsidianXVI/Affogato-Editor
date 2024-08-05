library affogato.editor;

import 'package:affogato_core/affogato_core.dart';
import 'package:affogato_editor/battery_langs/generic/language_bundle.dart';
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
  final Map<EditorInstanceHandle, AffogatoEditorInstance> editorInstances = {};
  late EditorInstanceHandle activeEditor;
  @override
  void initState() {
    activeEditor = provisionEditorInstance();
    super.initState();
  }

  EditorInstanceHandle provisionEditorInstance() {
    final EditorInstanceHandle handle = GlobalKey();
    editorInstances.addAll({
      handle: AffogatoEditorInstance(
        languageBundle: genericLB,
        themeBundle: themeBundle,
        editorConfigs: widget.editorConfigs,
        handle: handle,
        setEditorAsActive: (handle) => setState(() {
          activeEditor = handle;
        }),
      )
    });
    return handle;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.editorConfigs.backgroundColor,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            ...editorInstances.values,
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 20,
              child: StatusBar(),
            ),
          ],
        ),
      ),
    );
  }
}
