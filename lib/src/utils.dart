import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

/// Decodes a URI, returning the original string if decoding fails.
String decodeUri(String href) {
  try {
    return Uri.decodeFull(href);
  } catch (_) {
    return href;
  }
}

/*
extension EnumFromString<T extends Enum> on List<T> {
  T? find(String value) {
    final v = '$T.$value'.toUpperCase();
    return firstWhereOrNull((f) => f.toString().toUpperCase() == v);
  }
}
*/
/// Parses a byte array into an XML document.
XmlDocument xdocFromBytes(Uint8List bytes) =>
    XmlDocument.parse(utf8.decode(bytes));

/// Extension for converting an ArchiveFile to an XML document.
extension ArchiveFileExt on ArchiveFile {
  /// Returns the content of the file as an XML document.
  XmlDocument get xml => xdocFromBytes(content);
}

/// Extension for finding an attribute in an iterable of XML attributes.
extension XAttrFind on Iterable<XmlAttribute> {
  /// Finds the first attribute with the given name.
  XmlAttribute? find(String name) =>
      firstWhereOrNull((xa) => xa.name.local.toLowerCase() == name);
}

/// Returns the directory part of a file path.
String directoryFromFile({required String path}) {
  var lastSlashIndex = path.lastIndexOf('/');
  if (lastSlashIndex == -1) {
    return '';
  } else {
    return path.substring(0, lastSlashIndex);
  }
}

/// Combines a path and a href, resolving relative paths.
String combineHref({required String path, required String href}) {
  if (path.isEmpty) {
    while (href.startsWith('../') || href.startsWith('./')) {
      if (href.startsWith('./')) {
        href = href.substring(2);
      } else {
        href = href.substring(3);
      }
    }
    return href;
  }
  while (href.startsWith('../') || href.startsWith('./')) {
    if (href.startsWith('./')) {
      href = href.substring(2);
    } else {
      href = href.substring(3);
      final di = path.lastIndexOf('/');
      if (di < 0) return href;
      path = path.substring(0, di);
    }
  }
  return '$path/$href';
}
