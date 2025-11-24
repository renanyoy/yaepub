import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

import 'epub_spine_item_ref.dart';

class EpubSpine {
  final String? tableOfContents;
  final List<EpubSpineItemRef> items;
  final bool ltr;

  const EpubSpine({
    this.tableOfContents,
    this.items = const <EpubSpineItemRef>[],
    required this.ltr,
  });

  @override
  int get hashCode =>
      tableOfContents.hashCode ^
      const DeepCollectionEquality().hash(items) ^
      ltr.hashCode;

  @override
  bool operator ==(covariant EpubSpine other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.tableOfContents == tableOfContents &&
        listEquals(other.items, items) &&
        other.ltr == ltr;
  }

  factory EpubSpine.fromXml(XmlElement spineNode) {
    final items = <EpubSpineItemRef>[];
    final tableOfContents = spineNode.getAttribute('toc');
    final pageProgression =
        spineNode.getAttribute('page-progression-direction');
    final ltr =
        ((pageProgression == null) || pageProgression.toLowerCase() == 'ltr');
    spineNode.children.whereType<XmlElement>().forEach(
      (XmlElement spineItemNode) {
        if (spineItemNode.name.local.toLowerCase() == 'itemref') {
          String? idRef = spineItemNode.getAttribute('idref');
          if (idRef == null || idRef.isEmpty) {
            throw Exception('Incorrect EPUB spine: item ID ref is missing');
          }
          var linearAttribute = spineItemNode.getAttribute('linear');
          final isLinear = linearAttribute == null ||
              (linearAttribute.toLowerCase() == 'no');
          final spineItemRef = EpubSpineItemRef(
            idRef: idRef,
            isLinear: isLinear,
          );
          items.add(spineItemRef);
        }
      },
    );
    return EpubSpine(
      items: items,
      tableOfContents: tableOfContents,
      ltr: ltr,
    );
  }
}
