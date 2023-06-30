library affogato;

import 'package:flutter/material.dart';
import './style/style.dart';
import './components/components.dart';

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
                Positioned(
                  right: 0,
                  top: 0,
                  width: widget.width * 0.7,
                  height: widget.height,
                  child: EditorComponent(
                    theme: widget.theme,
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
