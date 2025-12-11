/// Represents an error that occurred while parsing an EPUB file.
class Berror extends Error {
  /// The error message.
  final String message;

  /// Creates a new Berror instance.
  Berror(this.message);
  @override
  String toString() => 'Berror(message: $message)';
}

/// Represents the version of an EPUB file.
enum Version {
  /// EPUB version 1
  epub1,

  /// EPUB version 2
  epub2,

  /// EPUB version 3
  epub3;

  /// Creates a new Version instance from a string.
  static Version from({required String string}) {
    if (string.startsWith('1.')) return epub1;
    if (string.startsWith('2.')) return epub2;
    if (string.startsWith('3.')) return epub3;
    throw Berror('version $string unimplemented');
  }
}
