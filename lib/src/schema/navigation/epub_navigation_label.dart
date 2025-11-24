// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

class EpubNavigationLabel {
  final String? text;

  const EpubNavigationLabel({
    this.text,
  });

  @override
  int get hashCode => text.hashCode;

  @override
  bool operator ==(covariant EpubNavigationLabel other) {
    if (identical(this, other)) return true;

    return other.text == text;
  }

  @override
  String toString() => '$text';

  factory EpubNavigationLabel.fromXml(
    XmlElement navigationLabelNode,
  ) {
    var navigationLabelTextNode = navigationLabelNode
        .findElements('text', namespace: navigationLabelNode.name.namespaceUri)
        .firstWhereOrNull((XmlElement? elem) => elem != null);
    if (navigationLabelTextNode == null) {
      throw Exception(
        'Incorrect EPUB navigation label: label text element is missing.',
      );
    }
    final text = navigationLabelTextNode.innerText;
    return EpubNavigationLabel(text: text);
  }

  factory EpubNavigationLabel.fromXmlV3(
    XmlElement navigationLabelNode,
  ) {
    final text = navigationLabelNode.innerText.trim();
    return EpubNavigationLabel(text: text);
  }
}
