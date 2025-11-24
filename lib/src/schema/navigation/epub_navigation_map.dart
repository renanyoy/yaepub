import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

import 'epub_navigation_point.dart';

class EpubNavigationMap {
  final List<EpubNavigationPoint> points;

  const EpubNavigationMap({
    this.points = const <EpubNavigationPoint>[],
  });

  @override
  int get hashCode => const DeepCollectionEquality().hash(points);

  @override
  bool operator ==(covariant EpubNavigationMap other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.points, points);
  }

  factory EpubNavigationMap.fromXml(XmlElement navigationMapNode) {
    final points = <EpubNavigationPoint>[];

    navigationMapNode.children
        .whereType<XmlElement>()
        .forEach((XmlElement navigationPointNode) {
      if (navigationPointNode.name.local.toLowerCase() == 'navpoint') {
        var navigationPoint = EpubNavigationPoint.fromXml(navigationPointNode);
        points.add(navigationPoint);
      }
    });
    return EpubNavigationMap(points: points);
  }

  factory EpubNavigationMap.fromXmlV3(
      String tocFileEntryPath, XmlElement navigationMapNode) {
    final points = <EpubNavigationPoint>[];

    navigationMapNode.children
        .whereType<XmlElement>()
        .forEach((XmlElement navigationPointNode) {
      if (navigationPointNode.name.local.toLowerCase() == 'li') {
        var navigationPoint = EpubNavigationPoint.fromXmlV3(
            tocFileEntryPath, navigationPointNode);
        points.add(navigationPoint);
      }
    });
    return EpubNavigationMap(points: points);
  }
}
