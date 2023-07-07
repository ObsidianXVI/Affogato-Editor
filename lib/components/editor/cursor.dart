part of affogato.components;

class Cursor extends StatefulWidget {
  int currentLine = 0;
  int currentCol = 0;

  Cursor({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => CursorState();
}

class CursorState extends State<Cursor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 2,
      decoration: const BoxDecoration(
        color: Colors.green,
      ),
    );
  }
}
