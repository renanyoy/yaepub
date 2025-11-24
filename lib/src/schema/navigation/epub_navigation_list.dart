import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

import 'epub_navigation_label.dart';
import 'epub_navigation_target.dart';

class EpubNavigationList {
  final String? id;
  final String? classs;
  final List<EpubNavigationLabel> navigationLabels;
  final List<EpubNavigationTarget> navigationTargets;

  const EpubNavigationList({
    this.id,
    this.classs,
    this.navigationLabels = const <EpubNavigationLabel>[],
    this.navigationTargets = const <EpubNavigationTarget>[],
  });

  @override
  int get hashCode {
    return id.hashCode ^
        classs.hashCode ^
        const DeepCollectionEquality().hash(navigationLabels) ^
        const DeepCollectionEquality().hash(navigationTargets);
  }

  @override
  bool operator ==(covariant EpubNavigationList other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.classs == classs &&
        listEquals(other.navigationLabels, navigationLabels) &&
        listEquals(other.navigationTargets, navigationTargets);
  }

    factory EpubNavigationList.fromXml(
    XmlElement navigationListNode,
  ) {
    String? id, classs;

    for (final attribute in navigationListNode.attributes) {
      final attributeValue = attribute.value;

      switch (attribute.name.local.toLowerCase()) {
        case 'id':
          id = attributeValue;
        case 'class':
          classs = attributeValue;
      }
    }

    final navigationLabels = <EpubNavigationLabel>[];
    final navigationTargets = <EpubNavigationTarget>[];
    for (final node
        in navigationListNode.children.whereType<XmlElement>()) {
      switch (node.name.local.toLowerCase()) {
        case 'navlabel':
          final navigationLabel = EpubNavigationLabel.fromXml(node);
          navigationLabels.add(navigationLabel);
        case 'navtarget':
          final navigationTarget = EpubNavigationTarget.fromXml(node);
          navigationTargets.add(navigationTarget);
      }
    }

    // if (result.NavigationLabels!.isEmpty) {
    //   throw Exception(
    //       'Incorrect EPUB navigation page target: at least one navLabel element is required.');
    // }
    return EpubNavigationList(
      id: id,
      classs: classs,
      navigationLabels: navigationLabels,
      navigationTargets: navigationTargets,
    );
  }
}
