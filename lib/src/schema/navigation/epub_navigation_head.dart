import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

import 'epub_navigation_head_meta.dart';

class EpubNavigationHead {
  final List<EpubNavigationHeadMeta> metadata;

  const EpubNavigationHead({
    this.metadata = const <EpubNavigationHeadMeta>[],
  });

  @override
  int get hashCode => const DeepCollectionEquality().hash(metadata);

  @override
  bool operator ==(covariant EpubNavigationHead other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.metadata, metadata);
  }

  factory EpubNavigationHead.fromXml(XmlElement headNode) {
    final metadata = <EpubNavigationHeadMeta>[];

    headNode.children.whereType<XmlElement>().forEach(
      (XmlElement metaNode) {
        if (metaNode.name.local.toLowerCase() == 'meta') {
          String? name, content, scheme;

          for (final metaNodeAttribute in metaNode.attributes) {
            final attributeValue = metaNodeAttribute.value;

            switch (metaNodeAttribute.name.local.toLowerCase()) {
              case 'name':
                name = attributeValue;
              case 'content':
                content = attributeValue;
              case 'scheme':
                scheme = attributeValue;
            }
          }

          if (name == null || name.isEmpty) {
            throw Exception(
              'Incorrect EPUB navigation meta: meta name is missing.',
            );
          }
          if (content == null) {
            throw Exception(
              'Incorrect EPUB navigation meta: meta content is missing.',
            );
          }

          final meta = EpubNavigationHeadMeta(
            name: name,
            content: content,
            scheme: scheme,
          );

          metadata.add(meta);
        }
      },
    );
    return EpubNavigationHead(metadata: metadata);
  }
}
