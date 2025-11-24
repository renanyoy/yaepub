import 'package:collection/collection.dart';
import 'package:xml/xml.dart';
import 'package:yaepub/src/utils.dart';

import 'epub_metadata.dart';
import 'epub_navigation_label.dart';
import 'epub_navigation_page_target_type.dart';

class EpubNavigationPageTarget {
  final String? id;
  final String? value;
  final EpubNavigationPageTargetType? type;
  final String? classs;
  final String? playOrder;
  final List<EpubNavigationLabel> navigationLabels;
  final EpubNavigationContent? content;

  const EpubNavigationPageTarget({
    this.id,
    this.value,
    this.type,
    this.classs,
    this.playOrder,
    this.navigationLabels = const <EpubNavigationLabel>[],
    this.content,
  });

  @override
  int get hashCode {
    return id.hashCode ^
        value.hashCode ^
        type.hashCode ^
        classs.hashCode ^
        playOrder.hashCode ^
        const DeepCollectionEquality().hash(navigationLabels) ^
        content.hashCode;
  }

  @override
  bool operator ==(covariant EpubNavigationPageTarget other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.value == value &&
        other.type == type &&
        other.classs == classs &&
        other.playOrder == playOrder &&
        listEquals(other.navigationLabels, navigationLabels) &&
        other.content == content;
  }

  factory EpubNavigationPageTarget.fromXml(
    XmlElement navigationPageTargetNode,
  ) {
    String? id, value, classs, playOrder;

    EpubNavigationPageTargetType? type;

    for (var attribute in navigationPageTargetNode.attributes) {
      var attributeValue = attribute.value;
      switch (attribute.name.local.toLowerCase()) {
        case 'id':
          id = attributeValue;
        case 'value':
          value = attributeValue;
        case 'type':
          type = EpubNavigationPageTargetType.values.find(attributeValue);
        case 'class':
          classs = attributeValue;
        case 'playorder':
          playOrder = attributeValue;
      }
    }
    if (type == EpubNavigationPageTargetType.undefined) {
      throw Exception(
        'Incorrect EPUB navigation page target: page target type is missing.',
      );
    }
    final navigationLabels = <EpubNavigationLabel>[];

    EpubNavigationContent? content;

    navigationPageTargetNode.children.whereType<XmlElement>().forEach((
      XmlElement navigationPageTargetChildNode,
    ) {
      switch (navigationPageTargetChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          var navigationLabel = EpubNavigationLabel.fromXml(
            navigationPageTargetChildNode,
          );
          navigationLabels.add(navigationLabel);
        case 'content':
          var content = EpubNavigationContent.fromXml(
            navigationPageTargetChildNode,
          );
          content = content;
      }
    });
    if (navigationLabels.isEmpty) {
      throw Exception(
        'Incorrect EPUB navigation page target: at least one navLabel element is required.',
      );
    }

    return EpubNavigationPageTarget(
      id: id,
      value: value,
      type: type,
      classs: classs,
      playOrder: playOrder,
      navigationLabels: navigationLabels,
      content: content,
    );
  }
}
