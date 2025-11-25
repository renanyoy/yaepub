import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:mime_type/mime_type.dart';
import 'package:xml/xml.dart';
import 'package:yaepub/src/utils.dart';

class Bfile {
  final ArchiveFile file;
  late final String mimeType;
  Bfile({required this.file, String? mimeType}) {
    this.mimeType = mimeType ?? mime(file.name) ?? 'application/octet-stream';
  }

  String get href => file.name.toLowerCase();
  Uint8List get content => file.content;
  XmlDocument get asXdoc => xdocFromBytes(content);

  static Map<String, Bfile> from({required Archive archive}) {
    final Map<String, Bfile> map = {};
    for (final f in archive.files) {
      final key = f.name.toLowerCase();
      map[key] = Bfile(file: f);
    }
    return map;
  }
}

class Mfile extends Bfile {
  String id;
  Mfile({required Bfile file, required this.id, super.mimeType})
    : super(file: file.file);
}

extension MapLowerCaseExt<T> on Map<String, T> {
  T? get(String key) => this[key.toLowerCase()];
}
