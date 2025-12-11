import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:mime_type/mime_type.dart';
import 'package:xml/xml.dart';
import 'package:yaepub/src/utils.dart';

/// Represents a file in the EPUB archive.
class Bfile {
  /// The underlying file in the archive.
  final ArchiveFile file;

  /// The MIME type of the file.
  late final String mimeType;

  /// Creates a new Bfile instance.
  ///
  /// The [file] is the underlying file in the archive.
  /// The [mimeType] is the MIME type of the file. If not provided, it will be
  /// inferred from the file name.
  Bfile({required this.file, String? mimeType}) {
    this.mimeType = mimeType ?? mime(file.name) ?? 'application/octet-stream';
  }

  /// The path of the file in the archive.
  String get href => file.name.toLowerCase();

  /// The content of the file as a byte array.
  Uint8List get content => file.content;

  /// The content of the file as an XML document.
  XmlDocument get asXdoc => xdocFromBytes(content);

  /// The content of the file as a string.
  String get asText => utf8.decode(content, allowMalformed: true);

  /// Creates a map of Bfile instances from an archive.
  ///
  /// The [archive] is the EPUB archive.
  /// Returns a map of Bfile instances, with their paths as keys.
  static Map<String, Bfile> from({required Archive archive}) {
    final Map<String, Bfile> map = {};
    for (final f in archive.files) {
      final key = f.name.toLowerCase();
      map[key] = Bfile(file: f);
    }
    return map;
  }
}

/// Represents a file in the manifest of the EPUB.
class Mfile extends Bfile {
  /// The ID of the file in the manifest.
  String id;

  /// Creates a new Mfile instance.
  ///
  /// The [file] is the underlying Bfile instance.
  /// The [id] is the ID of the file in the manifest.
  /// The [mimeType] is the MIME type of the file.
  Mfile({required Bfile file, required this.id, super.mimeType})
      : super(file: file.file);
}

/// Extension for maps with string keys to allow case-insensitive access.
extension MapLowerCaseExt<T> on Map<String, T> {
  /// Gets a value from the map, ignoring the case of the key.
  T? get(String key) => this[key.toLowerCase()];
}
