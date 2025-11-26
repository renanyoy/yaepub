// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'file.dart';
import 'utils.dart';

class Spine {
  String id;
  String linear;
  Mfile file;
  Spine({required this.id, required this.linear, required this.file});
  String combine({required String href}) {
    final path = directoryFromFile(path: file.href);
    return combineHref(path: path, href: decodeUri(href)).toLowerCase();
  }
}
