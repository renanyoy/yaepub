# yaepub

[![Pub Version](https://img.shields.io/pub/v/yaepub.svg)](https://pub.dev/packages/yaepub)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.10.0-blue.svg)](https://dart.dev)
[![style: lints](https://img.shields.io/badge/style-lints-4BC0F5.svg)](https://pub.dev/packages/lints)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Y**et **A**nother **EPUB** parser for Dart. 

`yaepub` is a lightweight, pure Dart library to extract content, structure, and metadata from EPUB files. It provides an intuitive API to parse EPUB 2/3 metadata, the manifest, the reading order (spine), and the table of contents.

## Features

- 📖 Extract essential book metadata (title, author, publisher, description, language, publication date, ISBN, UUID).
- 🖼️ Retrieve the book's cover image.
- 📚 Read the Table of Contents (Navigation) and Reading Order (Spine).
- 🗂️ Direct access to internal files and the manifest map.
- ⚡ Zero native dependencies; fully written in Dart.

## Installation

Add `yaepub` to your `pubspec.yaml`:

```yaml
dependencies:
  yaepub: ^1.0.0
```

Then run `dart pub get` or `flutter pub get`.

## Usage

Here is a quick example of how to use `yaepub` to parse an EPUB file:

```dart
import 'dart:io';
import 'package:yaepub/yaepub.dart';

Future<void> main() async {
  // 1. Read the EPUB file as bytes
  final file = File('path/to/your/book.epub');
  final bytes = await file.readAsBytes();

  // 2. Parse the EPUB book
  final book = Book.from(bytes: bytes);

  // 3. Access metadata
  print(book); // Book(title: "Book Title", author: "Book Author", language: "en")
  print('Publisher: ${book.publisher}');
  print('Date: ${book.date}');
  
  // 4. Access Structural Data
  print('Spine Items: ${book.spine.length}');
  print('Chapters/Nav: ${book.navigation.length}');
  
  // 5. Check if it has a cover
  if (book.cover != null) {
    print('Cover ID: ${book.cover!.id}');
  }
}
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request if you find bugs or want to add features.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
