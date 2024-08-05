part of affogato.editor;

class StatusBar extends StatelessWidget {
  final void Function(String newLB)? onLBChanged;

  const StatusBar({
    this.onLBChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: afLightBrown3,
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              /* ((instanceKey.currentState as AffogatoEditorState)
                  .activeEditor
                  .currentState as AffogatoEditorInstanceState); */
            },
            child: Text(
              (instanceKey.currentState!.activeEditor.currentWidget
                      as AffogatoEditorInstance)
                  .languageBundle
                  .bundleName,
              style: const TextStyle(color: afLightBrown1),
            ),
          ),
        ],
      ),
    );
  }
}
