enum EpubVersion {
  epub2,
  epub3;

  static EpubVersion? from({required String string}) {
    switch (string) {
      case '2.0':
        return EpubVersion.epub2;
      case '3.0':
        return EpubVersion.epub3;
      default:
        return null;
    }
  }
}
