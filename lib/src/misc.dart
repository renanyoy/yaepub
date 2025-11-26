class Berror extends Error {
  final String message;
  Berror(this.message);
  @override
  String toString() => 'Berror(message: $message)';
}

enum Version {
  epub1,
  epub2,
  epub3;

  static Version from({required String string}) {
    if (string.startsWith('1.')) return epub1;
    if (string.startsWith('2.')) return epub2;
    if (string.startsWith('3.')) return epub3;
    throw Berror('version $string unimplemented');
  }
}
