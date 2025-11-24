import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

import 'epub_navigation_page_target.dart';

class EpubNavigationPageList {
  final List<EpubNavigationPageTarget> targets;

  const EpubNavigationPageList({
    this.targets = const <EpubNavigationPageTarget>[],
  });

  @override
  int get hashCode => const DeepCollectionEquality().hash(targets);

  @override
  bool operator ==(covariant EpubNavigationPageList other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.targets, targets);
  }

  factory EpubNavigationPageList.fromXml(
    XmlElement navigationPageListNode,
  ) {
    final targets = <EpubNavigationPageTarget>[];
    for (final node
        in navigationPageListNode.children.whereType<XmlElement>()) {
      if (node.name.local.toLowerCase() == 'pagetarget') {
        final pageTarget = EpubNavigationPageTarget.fromXml(node);
        targets.add(pageTarget);
      }
    }
    return EpubNavigationPageList(targets: targets);
  }
}
