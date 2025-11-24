// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:xml/xml.dart';
import 'package:path/path.dart' as path;

class EpubNavigationContent {
  final String? id;
  final String? source;

  const EpubNavigationContent({
    this.id,
    this.source,
  });

  @override
  int get hashCode => id.hashCode ^ source.hashCode;

  @override
  bool operator ==(covariant EpubNavigationContent other) {
    if (identical(this, other)) return true;

    return other.id == id && other.source == source;
  }

  @override
  String toString() {
    return 'Source: $source';
  }

    factory EpubNavigationContent.fromXml(
    XmlElement navigationContentNode,
  ) {
    String? id, source;

    for (final attribute in navigationContentNode.attributes) {
      var attributeValue = attribute.value;
      switch (attribute.name.local.toLowerCase()) {
        case 'id':
          id = attributeValue;
        case 'src':
          source = attributeValue;
      }
    }
    if (source == null || source.isEmpty) {
      throw Exception(
        'Incorrect EPUB navigation content: content source is missing.',
      );
    }

    return EpubNavigationContent(
      id: id,
      source: source,
    );
  }

  factory EpubNavigationContent.fromXmlV3(
    String tocFileEntryPath,
    XmlElement navigationContentNode,
  ) {
    String? id, source;

    for (final attribute in navigationContentNode.attributes) {
      var attributeValue = attribute.value;

      switch (attribute.name.local.toLowerCase()) {
        case 'id':
          id = attributeValue;
        case 'href':
          if (tocFileEntryPath.length < 2 ||
              attributeValue.startsWith(tocFileEntryPath)) {
            source = attributeValue;
          } else {
            source = path.normalize(tocFileEntryPath + attributeValue);
          }
      }
    }
    // element with span, the content will be null;
    // if (result.Source == null || result.Source!.isEmpty) {
    //   throw Exception(
    //       'Incorrect EPUB navigation content: content source is missing.');
    // }
    return EpubNavigationContent(
      id: id,
      source: source,
    );
  }

}
