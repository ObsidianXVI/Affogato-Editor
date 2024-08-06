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
            onPressed: onLBChanged == null
                ? null
                : () {
                    final currentLB = instanceKey.currentState!.activeEditor
                        .currentState!.widget.languageBundle.bundleName;
                    // show dropdown with other options

                    onLBChanged!
                        .call(currentLB == 'Markdown' ? 'Generic' : 'Markdown');
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
