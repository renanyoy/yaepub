import 'dart:typed_data';

import 'package:archive/archive.dart';

class Book {
  Archive archive;
  Book({required this.archive});
  factory Book.from({required Uint8List bytes}) {
    final archive = ZipDecoder().decodeBytes(bytes);

    return Book(archive: archive);
  }
}
