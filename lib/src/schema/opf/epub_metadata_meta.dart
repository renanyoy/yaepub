import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

class EpubMetadataMeta {
  final String? name;
  final String? content;
  final String? id;
  final String? refines;
  final String? property;
  final String? scheme;
  final Map<String, String> attributes;

  const EpubMetadataMeta({
    this.name,
    this.content,
    this.id,
    this.refines,
    this.property,
    this.scheme,
    this.attributes = const <String, String>{},
  });

  @override
  int get hashCode {
    return name.hashCode ^
        content.hashCode ^
        id.hashCode ^
        refines.hashCode ^
        property.hashCode ^
        scheme.hashCode ^
        const DeepCollectionEquality().hash(attributes);
  }

  @override
  bool operator ==(covariant EpubMetadataMeta other) {
    if (identical(this, other)) return true;
    final mapEquals = const DeepCollectionEquality().equals;

    return other.name == name &&
        other.content == content &&
        other.id == id &&
        other.refines == refines &&
        other.property == property &&
        other.scheme == scheme &&
        mapEquals(other.attributes, attributes);
  }

  factory EpubMetadataMeta.fromXmlVersion2(
    XmlElement metadataMetaNode,
  ) {
    String? name, content;
    for (final attribute in metadataMetaNode.attributes) {
      final attributeValue = attribute.value;

      switch (attribute.name.local.toLowerCase()) {
        case 'name':
          name = attributeValue;
        case 'content':
          content = attributeValue;
      }
    }
    return EpubMetadataMeta(
      name: name,
      content: content,
    );
  }

  factory EpubMetadataMeta.fromXmlVersion3(XmlElement metadataMetaNode) {
    final attributes = <String, String>{};
    String? id, refines, property, scheme, content;
    for (var metadataMetaNodeAttribute in metadataMetaNode.attributes) {
      final attributeValue = metadataMetaNodeAttribute.value;

      final name = metadataMetaNodeAttribute.name.local.toLowerCase();

      attributes[name] = attributeValue;
      switch (name) {
        case 'id':
          id = attributeValue;
        case 'refines':
          refines = attributeValue;
        case 'property':
          property = attributeValue;
        case 'scheme':
          scheme = attributeValue;
      }
    }
    content = metadataMetaNode.innerText;

    return EpubMetadataMeta(
      id: id,
      refines: refines,
      property: property,
      scheme: scheme,
      content: content,
      attributes: attributes,
    );
  }
}
