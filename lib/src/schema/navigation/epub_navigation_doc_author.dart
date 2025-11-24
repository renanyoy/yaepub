import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

class EpubNavigationDocAuthor {
  final List<String> authors;

  const EpubNavigationDocAuthor({
    this.authors = const <String>[],
  });

  @override
  int get hashCode => const DeepCollectionEquality().hash(authors);

  @override
  bool operator ==(covariant EpubNavigationDocAuthor other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.authors, authors);
  }

  factory EpubNavigationDocAuthor.fromXml(
    XmlElement docAuthorNode,
  ) {
    final authors = <String>[];
    docAuthorNode.children.whereType<XmlElement>().forEach(
      (XmlElement textNode) {
        if (textNode.name.local.toLowerCase() == 'text') {
          authors.add(textNode.innerText);
        }
      },
    );
    return EpubNavigationDocAuthor(authors: authors);
  }
}
