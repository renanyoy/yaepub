import 'dart:io';
import 'package:yaepub/yaepub.dart';

Future<void> main() async {
  final f = File('example/vulkan-cookbook.epub');
  final bytes = await f.readAsBytes();
  final book = Book.from(bytes: bytes);
  print('book: $book');
}
