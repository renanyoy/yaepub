import 'dart:io';
import 'package:test/test.dart';
import 'package:yaepub/yaepub.dart';

void main() {
  group('Book parsing tests', () {
    late Book book;

    setUpAll(() async {
      final file = File('test/vulkan-cookbook.epub');
      final bytes = await file.readAsBytes();
      book = Book.from(bytes: bytes);
    });

    test('Parse basic metadata', () {
      expect(book.title, 'Vulkan Cookbook');
      expect(book.author, 'Pawel Lapinski');
      expect(book.language, 'en');
      expect(book.publisher, 'Packt Publishing');
      expect(book.date?.year, 2017);
      expect(book.date?.month, 4);
      expect(book.date?.day, 28);
    });

    test('Parse structural metadata', () {
      expect(book.spine.length, 828);
      expect(book.navigation.length, 13);
      expect(book.cover?.id, 'cover');
    });

    test('Files map and manifest map', () {
      expect(book.files.isNotEmpty, isTrue);
      expect(book.manifest.isNotEmpty, isTrue);
      expect(book.manifest['cover'], isNotNull);
    });
  });
}
