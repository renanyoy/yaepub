// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

import 'epub_navigation_content.dart';
import 'epub_navigation_label.dart';
import 'epub_navigation_map.dart';

class EpubNavigationPoint {
  final String? id;
  final String? classs;
  final String? playOrder;
  final List<EpubNavigationLabel> navigationLabels;
  final EpubNavigationContent? content;
  final List<EpubNavigationPoint> childNavigationPoints;

  const EpubNavigationPoint({
    this.id,
    this.classs,
    this.playOrder,
    this.navigationLabels = const <EpubNavigationLabel>[],
    this.content,
    this.childNavigationPoints = const <EpubNavigationPoint>[],
  });

  @override
  int get hashCode {
    return id.hashCode ^
        classs.hashCode ^
        playOrder.hashCode ^
        const DeepCollectionEquality().hash(navigationLabels) ^
        content.hashCode ^
        const DeepCollectionEquality().hash(childNavigationPoints);
  }

  @override
  bool operator ==(covariant EpubNavigationPoint other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.classs == classs &&
        other.playOrder == playOrder &&
        listEquals(other.navigationLabels, navigationLabels) &&
        other.content == content &&
        listEquals(other.childNavigationPoints, childNavigationPoints);
  }

  @override
  String toString() {
    return 'Id: $id, Content.Source: ${content?.source}';
  }

  factory EpubNavigationPoint.fromXml(XmlElement navigationPointNode) {
    String? id, classs, playOrder;
    for (final attribute in navigationPointNode.attributes) {
      var attributeValue = attribute.value;
      switch (attribute.name.local.toLowerCase()) {
        case 'id':
          id = attributeValue;
        case 'class':
          classs = attributeValue;
        case 'playorder':
          playOrder = attributeValue;
      }
    }
    if (id == null || id.isEmpty) {
      throw Exception('Incorrect EPUB navigation point: point ID is missing.');
    }
    EpubNavigationContent? content;

    final navigationLabels = <EpubNavigationLabel>[];
    final childNavigationPoints = <EpubNavigationPoint>[];
    navigationPointNode.children.whereType<XmlElement>().forEach(
      (XmlElement navigationPointChildNode) {
        switch (navigationPointChildNode.name.local.toLowerCase()) {
          case 'navlabel':
            var navigationLabel =
                EpubNavigationLabel.fromXml(navigationPointChildNode);
            navigationLabels.add(navigationLabel);
          case 'content':
            final navContent =
                EpubNavigationContent.fromXml(navigationPointChildNode);
            content = navContent;
          case 'navpoint':
            var childNavigationPoint =
                EpubNavigationPoint.fromXml(navigationPointChildNode);
            childNavigationPoints.add(childNavigationPoint);
        }
      },
    );

    if (navigationLabels.isEmpty) {
      throw Exception(
        'EPUB parsing error: navigation point $id should contain at least one navigation label.',
      );
    }
    if (content == null) {
      throw Exception(
        'EPUB parsing error: navigation point $id should contain content.',
      );
    }

    return EpubNavigationPoint(
      id: id,
      classs: classs,
      playOrder: playOrder,
      navigationLabels: navigationLabels,
      content: content,
      childNavigationPoints: childNavigationPoints,
    );
  }

  factory EpubNavigationPoint.fromXmlV3(
    String tocFileEntryPath,
    XmlElement navigationPointNode,
  ) {
    String? id, classs, playOrder;

    EpubNavigationContent? content;

    final navigationLabels = <EpubNavigationLabel>[];
    final childNavigationPoints = <EpubNavigationPoint>[];
    navigationPointNode.children.whereType<XmlElement>().forEach(
      (XmlElement navigationPointChildNode) {
        switch (navigationPointChildNode.name.local.toLowerCase()) {
          case 'a':
          case 'span':
            final label =
                EpubNavigationLabel.fromXmlV3(navigationPointChildNode);
            navigationLabels.add(label);
            final navContent = EpubNavigationContent.fromXmlV3(
                tocFileEntryPath, navigationPointChildNode);
            content = navContent;
          case 'ol':
            for (final point in EpubNavigationMap.fromXmlV3(
                    tocFileEntryPath, navigationPointChildNode)
                .points) {
              childNavigationPoints.add(point);
            }
        }
      },
    );

    if (navigationLabels.isEmpty) {
      throw Exception(
        'EPUB parsing error: navigation point $id should contain at least one navigation label.',
      );
    }
    if (content == null) {
      throw Exception(
        'EPUB parsing error: navigation point $id should contain content.',
      );
    }

    return EpubNavigationPoint(
      id: id,
      classs: classs,
      playOrder: playOrder,
      navigationLabels: navigationLabels,
      content: content,
      childNavigationPoints: childNavigationPoints,
    );
  }
}
