import 'package:affogato/style/style.dart';

import 'affogato.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const AffogatoWidget(
      width: 1460,
      height: 820,
      theme: AffogatoWidgetTheme(
        widgetBackground: Color(0xFF0e001a),
        editorBackground: Color(0xFF120020),
        primaryColor: Colors.pink,
      ),
    ),
  );
}
