import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

import '../../utils.dart';
import 'epub_manifest_item.dart';

class EpubManifest {
  final List<EpubManifestItem> items;

  const EpubManifest({
    this.items = const <EpubManifestItem>[],
  });

  @override
  int get hashCode => const DeepCollectionEquality().hash(items);

  @override
  bool operator ==(covariant EpubManifest other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.items, items);
  }

  factory EpubManifest.fromXml(XmlElement manifestNode) {
    final items = <EpubManifestItem>[];
    manifestNode.children
        .whereType<XmlElement>()
        .forEach((XmlElement manifestItemNode) {
      if (manifestItemNode.name.local.toLowerCase() == 'item') {
        String? id,
            href,
            mediaType,
            mediaOverlay,
            requiredNamespace,
            requiredModules,
            fallback,
            fallbackStyle,
            properties;
        for (var manifestItemNodeAttribute in manifestItemNode.attributes) {
          var attributeValue = manifestItemNodeAttribute.value;
          switch (manifestItemNodeAttribute.name.local.toLowerCase()) {
            case 'id':
              id = attributeValue;
            case 'href':
              try {
                href = decodeUri(attributeValue);
              } catch (_) {
                href = attributeValue;
              }
            case 'media-type':
              mediaType = attributeValue;
            case 'media-overlay':
              mediaOverlay = attributeValue;
            case 'required-namespace':
              requiredNamespace = attributeValue;
            case 'required-modules':
              requiredModules = attributeValue;
            case 'fallback':
              fallback = attributeValue;
            case 'fallback-style':
              fallbackStyle = attributeValue;
            case 'properties':
              properties = attributeValue;
          }
        }

        if (id == null || id.isEmpty) {
          throw Exception('Incorrect EPUB manifest: item ID is missing');
        }
        if (href == null || href.isEmpty) {
          throw Exception('Incorrect EPUB manifest: item href is missing');
        }
        if (mediaType == null || mediaType.isEmpty) {
          throw Exception(
            'Incorrect EPUB manifest: item media type is missing',
          );
        }
        final manifestItem = EpubManifestItem(
          id: id,
          href: href,
          mediaType: mediaType,
          mediaOverlay: mediaOverlay,
          requiredNamespace: requiredNamespace,
          requiredModules: requiredModules,
          fallback: fallback,
          fallbackStyle: fallbackStyle,
          properties: properties,
        );

        items.add(manifestItem);
      }
    });
    return EpubManifest(items: items);
  }

  EpubManifestItem? find({String? id, String? href}) {
    if (id != null && href != null) {
      return items.firstWhereOrNull((i) => i.id == id && href == href);
    }
    if (id != null) return items.firstWhereOrNull((i) => i.id == id);
    if (href != null) return items.firstWhereOrNull((i) => i.href == href);
    return null;
  }
}
