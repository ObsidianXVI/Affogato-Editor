library affogato.engine;

import 'dart:js_util';

import 'package:affogato/components/components.dart';
import 'package:affogato/parser/parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

part './affogato_document.dart';

class AffogatoEngine {
  final AffogatoDocument document;
  final AffogatoLanguageBundle languageBundle;
  final AffogatoEditor editor;

  const AffogatoEngine({
    required this.document,
    required this.languageBundle,
    required this.editor,
  });
}
