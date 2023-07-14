library affogato.components;

import 'package:affogato/style/style.dart';
import 'package:affogato/engine/engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
part './editor/editor.dart';
part './file_tab_nav.dart';
part './editor/editor_line.dart';
part './editor/cursor.dart';
part './editor/char_cell.dart';
part './editor/cell_style.dart';
part './events.dart';

abstract class AffogatoComponent extends StatefulWidget {
  final AffogatoWidgetTheme theme;

  const AffogatoComponent({
    required this.theme,
  });
}
