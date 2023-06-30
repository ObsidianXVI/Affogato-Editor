library affogato.components;

import 'package:affogato/style/style.dart';
import 'package:flutter/material.dart';

abstract class AffogatoComponent extends StatelessWidget {
  final AffogatoWidgetTheme theme;

  const AffogatoComponent({
    required this.theme,
  });
}

class EditorComponent extends AffogatoComponent {
  const EditorComponent({
    required super.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: theme.editorBackground,
      ),
      child: TextField(
        decoration: InputDecoration(
          disabledBorder: InputBorder.none,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: false,
        ),
        enabled: true,
        expands: true,
        maxLines: null,
        minLines: null,
      ),
    );
  }
}
