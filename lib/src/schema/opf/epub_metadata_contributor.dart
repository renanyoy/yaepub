import 'package:xml/xml.dart';

class EpubMetadataContributor {
  final String? contributor;
  final String? fileAs;
  final String? role;

  const EpubMetadataContributor({
    this.contributor,
    this.fileAs,
    this.role,
  });

  @override
  int get hashCode => contributor.hashCode ^ fileAs.hashCode ^ role.hashCode;

  @override
  bool operator ==(covariant EpubMetadataContributor other) {
    if (identical(this, other)) return true;

    return other.contributor == contributor &&
        other.fileAs == fileAs &&
        other.role == role;
  }

  factory EpubMetadataContributor.fromXml(XmlElement metadataContributorNode) {
    String? contributor, role, fileAs;
    for (final attribute in metadataContributorNode.attributes) {
      final attributeValue = attribute.value;
      switch (attribute.name.local.toLowerCase()) {
        case 'role':
          role = attributeValue;
        case 'file-as':
          fileAs = attributeValue;
      }
    }
    contributor = metadataContributorNode.innerText;
    return EpubMetadataContributor(
      contributor: contributor,
      role: role,
      fileAs: fileAs,
    );
  }
}
