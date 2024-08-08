part of affogato.editor;

/// Provides a middleman between the [AffogatoEditorFieldController] and the
/// underlying target document being modified.
abstract class AffogatoDocumentProvider {
  final String fileName;
  bool hasChanges = false;

  AffogatoDocumentProvider({
    required this.fileName,
  });

  void saveDocument();

  String getContents();
}

class LocalDocumentProvider extends AffogatoDocumentProvider {
  final String path;

  LocalDocumentProvider({
    required this.path,
    required super.fileName,
  });

  @override
  String getContents() => 'local file';

  @override
  void saveDocument() {}
}

class EmptyDocumentProvider extends AffogatoDocumentProvider {
  EmptyDocumentProvider() : super(fileName: 'Untitled document');

  @override
  String getContents() => '';

  @override
  void saveDocument() {
    // TODO: implement saveDocument
  }
}
