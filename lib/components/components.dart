library affogato.components;

import 'package:affogato/style/style.dart';
import 'package:affogato/core/affogato_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
part './editor.dart';
part './file_tab_nav.dart';
part './editor_line.dart';

abstract class AffogatoComponent extends StatefulWidget {
  final AffogatoWidgetTheme theme;

  const AffogatoComponent({
    required this.theme,
  });
}
