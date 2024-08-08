part of affogato.editor;

class EditorFileTab extends StatefulWidget {
  final AffogatoEditorInstance instance;

  EditorFileTab({
    required this.instance,
  }) : super(
            key: ValueKey(
                '${instance.documentProvider.fileName}${instanceKey.currentState!.activeEditor == instance.handle}'));

  @override
  State<StatefulWidget> createState() => EditorFileTabState();
}

class EditorFileTabState extends State<EditorFileTab> {
  bool active = false;

  @override
  void initState() {
    active = instanceKey.currentState!.activeEditor == widget.instance.handle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 60,
      decoration: BoxDecoration(
        color: active ? afBrown : Colors.black,
      ),
      child: Center(
        child: Text(
          widget.instance.documentProvider.fileName,
          style: const TextStyle(color: afLightBrown1),
        ),
      ),
    );
  }
}
