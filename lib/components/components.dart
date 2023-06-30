library affogato.components;

import 'package:affogato/style/style.dart';
import 'package:flutter/material.dart';

abstract class AffogatoComponent extends StatefulWidget {
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
  State<StatefulWidget> createState() => EditorState();
}

class EditorState extends State<EditorComponent> {
  final TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final int lineCount = editingController.text.split('\n').length;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: widget.theme.editorBackground,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            height: double.infinity,
            child: Column(children: [
              const SizedBox(height: 7.5),
              ...List<Widget>.generate(lineCount, (int i) {
                return Center(
                  child: Container(
                    width: 40,
                    height: 24,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 2,
                          right: 5,
                          child: Text(
                            i.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.4,
                              fontFamily: 'DMMono',
                              color: widget.theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ]),
          ),
          Expanded(
            child: SizedBox(
              child: TextField(
                controller: editingController,
                onChanged: (String text) {
                  setState(() {});
                },
                style: TextStyle(
                  fontSize: 18,
                  height: 1.4,
                  fontFamily: 'DMMono',
                  color: widget.theme.primaryColor,
                ),
                decoration: const InputDecoration(
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
            ),
          ),
        ],
      ),
    );
  }
}
