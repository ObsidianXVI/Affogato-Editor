import 'package:affogato/style/style.dart';

import 'affogato.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const AffogatoWidget(
      width: 1100,
      height: 700,
      theme: AffogatoWidgetTheme(
        widgetBackground: Color(0xFF120020),
        editorBackground: Color(0xFF50008f),
        primaryColor: Colors.pink,
      ),
    ),
  );
}
