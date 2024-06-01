part of affogato.editor.battery.themes.affogato;

abstract class AffogatoRenderToken extends RenderToken<TextStyle> {
  AffogatoRenderToken(super.node);
}

class HeaderBoldRenderToken extends AffogatoRenderToken {
  HeaderBoldRenderToken(super.node);

  @override
  TextStyle render() => const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      );
}

class DefaultPlainTextRenderToken extends AffogatoRenderToken {
  DefaultPlainTextRenderToken(super.node);

  @override
  TextStyle render() => const TextStyle(color: Colors.white);
}
