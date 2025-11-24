import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

class EpubNavigationDocTitle {
  final List<String> titles;

  const EpubNavigationDocTitle({
    this.titles = const <String>[],
  });

  @override
  int get hashCode => const DeepCollectionEquality().hash(titles);

  @override
  bool operator ==(covariant EpubNavigationDocTitle other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.titles, titles);
  }

  factory EpubNavigationDocTitle.fromXml(
    XmlElement docTitleNode,
  ) {
    final titles = <String>[];
    docTitleNode.children.whereType<XmlElement>().forEach(
      (XmlElement textNode) {
        if (textNode.name.local.toLowerCase() == 'text') {
          titles.add(textNode.innerText);
        }
      },
    );
    return EpubNavigationDocTitle(titles: titles);
  }
}
