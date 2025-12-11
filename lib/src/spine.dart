import 'file.dart';
import 'utils.dart';

/// Represents an item in the EPUB's spine.
class Spine {
  /// The ID of the spine item.
  String id;

  /// The linear attribute of the spine item.
  String linear;

  /// The file associated with the spine item.
  Mfile file;

  /// Creates a new Spine instance.
  Spine({required this.id, required this.linear, required this.file});

  /// Combines a given href with the path of the spine item's file.
  String combine({required String href}) {
    final path = directoryFromFile(path: file.href);
    return combineHref(path: path, href: decodeUri(href)).toLowerCase();
  }
}
