import 'package:xml/xml.dart';

class EpubMetadataIdentifier {
  final String? id;
  final String? scheme;
  final String? identifier;

  const EpubMetadataIdentifier({
    this.id,
    this.scheme,
    this.identifier,
  });

  @override
  int get hashCode => id.hashCode ^ scheme.hashCode ^ identifier.hashCode;

  @override
  bool operator ==(covariant EpubMetadataIdentifier other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.scheme == scheme &&
        other.identifier == identifier;
  }

  factory EpubMetadataIdentifier.fromXml(XmlElement metadataIdentifierNode) {
    String? id, scheme, identifier;
    for (final attribute in metadataIdentifierNode.attributes) {
      final attributeValue = attribute.value;
      switch (attribute.name.local.toLowerCase()) {
        case 'id':
          id = attributeValue;
        case 'scheme':
          scheme = attributeValue;
      }
    }
    identifier = metadataIdentifierNode.innerText;
    return EpubMetadataIdentifier(
      id: id,
      scheme: scheme,
      identifier: identifier,
    );
  }
}
