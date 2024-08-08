part of affogato.editor;

class PrimaryBar extends StatelessWidget {
  final bool expanded;
  final void Function(String) onTap;

  const PrimaryBar({
    required this.expanded,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: expanded ? 240 : 50,
      height: double.infinity,
      color: afBrown,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: IconButton(
              onPressed: () {
                onTap('FileNavigator');
              },
              icon: const Icon(
                Icons.folder_open,
                color: afLightBrown3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
