// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

String decodeUri(String href) {
  try {
    return Uri.decodeFull(href);
  } catch (_) {
    return href;
  }
}

extension EnumFromString<T extends Enum> on List<T> {
  T? find(String value) {
    final v = '$T.$value'.toUpperCase();
    return firstWhereOrNull((f) => f.toString().toUpperCase() == v);
  }
}

XmlDocument xdocFromBytes(Uint8List bytes) =>
    XmlDocument.parse(utf8.decode(bytes));

extension ArchiveFileExt on ArchiveFile {
  XmlDocument get xml => xdocFromBytes(content);
}

extension XAttrFind on Iterable<XmlAttribute> {
  XmlAttribute? find(String name) =>
      firstWhereOrNull((xa) => xa.name.local.toLowerCase() == name);
}

String directoryFromFile({required String path}) {
  var lastSlashIndex = path.lastIndexOf('/');
  if (lastSlashIndex == -1) {
    return '';
  } else {
    return path.substring(0, lastSlashIndex);
  }
}

String combine({required String path, required String href}) {
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
