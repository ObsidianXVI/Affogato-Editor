library affogato.editor.battery.themes.affogato;

import 'package:affogato_core/affogato_core.dart';
import 'package:flutter/material.dart';

part './synax_highlighter.dart';
part './render_token.dart';

final ThemeBundle<AffogatoRenderToken, AffogatoSyntaxHighlighter> themeBundle =
    ThemeBundle(synaxHighlighter: AffogatoSyntaxHighlighter());
