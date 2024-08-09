part of affogato.editor;

class AffogatoEditorPanel extends StatelessWidget {
  final List<AffogatoEditorInstance> instances;
  final double width;
  final double height;

  const AffogatoEditorPanel({
    required this.width,
    required this.height,
    required this.instances,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: AffogatoEditorPanelData(
        width: width,
        height: height - 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (final instance in instances)
                  EditorFileTab(
                    instance: instance,
                  ),
              ],
            ),
            Row(
              children: instances,
            ),
          ],
        ),
      ),
    );
  }
}

class AffogatoEditorPanelData extends InheritedWidget {
  final double width;
  final double height;

  const AffogatoEditorPanelData({
    required this.width,
    required this.height,
    required super.child,
    super.key,
  });

  static AffogatoEditorPanelData of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AffogatoEditorPanelData>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      (oldWidget is AffogatoEditorPanelData) &&
      !(oldWidget.width == width && oldWidget.height == height);
}
