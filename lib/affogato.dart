library affogato;

import 'package:affogato/engine/engine.dart';
import 'package:flutter/material.dart';
import './style/style.dart';
import './components/components.dart';
import './temp_src.dart';

class AffogatoWidget extends StatefulWidget {
  final double width;
  final double height;
  final AffogatoWidgetTheme theme;
  const AffogatoWidget({
    required this.theme,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => AffogatoWidgetState();
}

class AffogatoWidgetState extends State<AffogatoWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Center(
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.theme.widgetBackground,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Stack(
              children: [
                const Positioned(
                  top: 0,
                  left: 0,
                  child: FileTabNavComponent(),
                ),
                Positioned(
                  right: 0,
                  top: 50,
                  child: AffogatoEditor(
                    width: widget.width * 0.78,
                    height: widget.height,
                    theme: widget.theme,
                    document: AffogatoDocument.fromString(src1),
                  ),
                )
              ],
            ),
/*           child: Material(
            child: Align(
              alignment: Alignment.centerLeft,
              child: EditorComponent(),
            ),
          ), */
          ),
        ),
      ),
    );
  }
}
