import 'package:collection/collection.dart';

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

