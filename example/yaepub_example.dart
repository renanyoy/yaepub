import 'dart:io';
import 'package:yaepub/yaepub.dart';

Future<void> main() async {
  final f = File('/Volumes/livres/ebooks/Abigail Keam/Death By Drowning (12056)/Death By Drowning - Abigail Keam.epub');
  final bytes = await f.readAsBytes();
  final book = Book.from(bytes: bytes);
  print('book: $book');
}
