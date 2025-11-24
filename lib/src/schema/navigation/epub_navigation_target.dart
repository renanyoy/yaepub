import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

import 'epub_navigation_content.dart';
import 'epub_navigation_label.dart';

class EpubNavigationTarget {
  final String? id;
  final String? classs;
  final String? value;
  final String? playOrder;
  final List<EpubNavigationLabel> navigationLabels;
  final EpubNavigationContent? content;

  const EpubNavigationTarget({
    this.id,
    this.classs,
    this.value,
    this.playOrder,
    this.navigationLabels = const <EpubNavigationLabel>[],
    this.content,
  });

  @override
  int get hashCode {
    return id.hashCode ^
        classs.hashCode ^
        value.hashCode ^
        playOrder.hashCode ^
        const DeepCollectionEquality().hash(navigationLabels) ^
        content.hashCode;
  }

  @override
  bool operator ==(covariant EpubNavigationTarget other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.classs == classs &&
        other.value == value &&
        other.playOrder == playOrder &&
        listEquals(other.navigationLabels, navigationLabels) &&
        other.content == content;
  }

  factory EpubNavigationTarget.fromXml(XmlElement navigationTargetNode) {
    String? id, classs, value, playOrder;

    for (var attribute in navigationTargetNode.attributes) {
      final attributeValue = attribute.value;

      switch (attribute.name.local.toLowerCase()) {
        case 'id':
          id = attributeValue;
        case 'value':
          value = attributeValue;
        case 'class':
          classs = attributeValue;
        case 'playorder':
          playOrder = attributeValue;
      }
    }
    if (id == null || id.isEmpty) {
      throw Exception(
        'Incorrect EPUB navigation target: navigation target ID is missing.',
      );
    }

    final navigationLabels = <EpubNavigationLabel>[];

    EpubNavigationContent? content;

    navigationTargetNode.children.whereType<XmlElement>().forEach(
      (XmlElement navigationTargetChildNode) {
        switch (navigationTargetChildNode.name.local.toLowerCase()) {
          case 'navlabel':
            final label =
                EpubNavigationLabel.fromXml(navigationTargetChildNode);
            navigationLabels.add(label);
          case 'content':
            final navContent =
                EpubNavigationContent.fromXml(navigationTargetChildNode);
            content = navContent;
        }
      },
    );
    if (navigationLabels.isEmpty) {
      throw Exception(
        'Incorrect EPUB navigation target: at least one navLabel element is required.',
      );
    }

    return EpubNavigationTarget(
      id: id,
      classs: classs,
      value: value,
      playOrder: playOrder,
      navigationLabels: navigationLabels,
      content: content,
    );
  }
}
