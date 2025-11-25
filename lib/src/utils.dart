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
  late final StackTrace stack;
  Berror(this.message) {
    stack = StackTrace.current;
  }
}

enum Version {
  v1,
  v2,
  v3;

  static Version from({required String string}) {
    if (string.startsWith('1.')) return v1;
    if (string.startsWith('2.')) return v2;
    if (string.startsWith('3.')) return v3;
    throw Berror('version $string unimplemented');
  }
}
