library affogato.components;

import 'package:affogato/style/style.dart';
import 'package:affogato/core/affogato_core.dart';
import 'package:flutter/material.dart';

abstract class AffogatoComponent extends StatefulWidget {
  final AffogatoWidgetTheme theme;

  const AffogatoComponent({
    required this.theme,
  });
}

class EditorComponent extends AffogatoComponent {
  final AffogatoDocument document;
  final double width;
  final double height;

  const EditorComponent({
    required super.theme,
    required this.width,
    required this.height,
    required this.document,
  });

  @override
  State<StatefulWidget> createState() => EditorState();
}

class EditorState extends State<EditorComponent> {
  @override
  Widget build(BuildContext context) {
    final int lineCount = widget.document.sourceLines.length;
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.theme.editorBackground,
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 70,
                child: Column(
                  children: [
                    const SizedBox(height: 7.5),
                    ...List<Widget>.generate(lineCount, (int i) {
                      return Center(
                        child: Container(
                          width: double.infinity,
                          height: 28,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color:
                                    widget.theme.primaryColor.withOpacity(0.3),
                              ),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 2,
                                right: 25,
                                child: Text(
                                  i.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    height: 1.4,
                                    fontFamily: 'DMMono',
                                    color: widget.theme.primaryColor
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 7.5),
                    ...List<Widget>.generate(lineCount, (int i) {
                      return Center(
                        child: Container(
                          width: double.infinity,
                          height: 28,
                          child: SelectableText.rich(
                            TextSpan(
                              text: widget.document.sourceLines[i],
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.4,
                                fontFamily: 'DMMono',
                                color: widget.theme.primaryColor,
                              ),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
