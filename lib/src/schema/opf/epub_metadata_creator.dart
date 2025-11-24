import 'package:xml/xml.dart';

class EpubMetadataCreator {
  final String? creator;
  final String? fileAs;
  final String? role;

  const EpubMetadataCreator({
    this.creator,
    this.fileAs,
    this.role,
  });

  @override
  int get hashCode => creator.hashCode ^ fileAs.hashCode ^ role.hashCode;

  @override
  bool operator ==(covariant EpubMetadataCreator other) {
    if (identical(this, other)) return true;

    return other.creator == creator &&
        other.fileAs == fileAs &&
        other.role == role;
  }

  factory EpubMetadataCreator.fromXml(XmlElement metadataCreatorNode) {
    String? creator, role, fileAs;
    for (final attribute in metadataCreatorNode.attributes) {
      final attributeValue = attribute.value;

      switch (attribute.name.local.toLowerCase()) {
        case 'role':
          role = attributeValue;
        case 'file-as':
          fileAs = attributeValue;
      }
    }
    creator = metadataCreatorNode.innerText;
    return EpubMetadataCreator(
      creator: creator,
      role: role,
      fileAs: fileAs,
    );
  }
}
