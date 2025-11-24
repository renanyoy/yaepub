// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

import 'epub_guide_reference.dart';

class EpubGuide {
  final List<EpubGuideReference> items;

  const EpubGuide({
    this.items = const <EpubGuideReference>[],
  });

  @override
  int get hashCode => const DeepCollectionEquality().hash(items);

  @override
  bool operator ==(covariant EpubGuide other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.items, items);
  }

  factory EpubGuide.fromXml(XmlElement guideNode) {
    final items = <EpubGuideReference>[];
    guideNode.children.whereType<XmlElement>().forEach(
      (XmlElement guideReferenceNode) {
        if (guideReferenceNode.name.local.toLowerCase() == 'reference') {
          String? type, title, href;

          for (final attribute in guideReferenceNode.attributes) {
            final attributeValue = attribute.value;

            switch (attribute.name.local.toLowerCase()) {
              case 'type':
                type = attributeValue;
              case 'title':
                title = attributeValue;
              case 'href':
                href = attributeValue;
            }
          }
          if (type == null || type.isEmpty) {
            throw Exception('Incorrect EPUB guide: item type is missing');
          }
          if (href == null || href.isEmpty) {
            throw Exception('Incorrect EPUB guide: item href is missing');
          }

          final guideReference = EpubGuideReference(
            type: type,
            title: title,
            href: href,
          );

          items.add(guideReference);
        }
      },
    );
    return EpubGuide(items: items);
  }
}
