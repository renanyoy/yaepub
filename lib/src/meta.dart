// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

import 'utils.dart';

class Xitem {
  late final String name;
  late final String value;
  final Map<String, String> attributes = {};
  Xitem(XmlElement xi) {
    final ename = xi.name.local.toLowerCase();
    if (ename == 'meta') {
      final property = xi.attributes.find('property');
      final aname = xi.attributes.find('name');
      final content = xi.attributes.find('content');
      if (property != null) {
        name =
            (property.value.contains(':')
                    ? property.value.split(':')[1]
                    : property.value)
                .trim();
        value = xi.innerText.trim();
        for (final xa in xi.attributes) {
          final xname = xa.name.local.toLowerCase();
          if (xname == 'property') continue;
          attributes[xname] = xa.value.trim();
        }
        return;
      } else if (aname != null && content != null) {
        name = aname.value.toLowerCase();
        value = content.value.trim();
        for (final xa in xi.attributes) {
          final xname = xa.name.local.toLowerCase();
          if (xname == 'content') continue;
          attributes[xname] = xa.value.trim();
        }
        return;
      } else {
        print('unimplemented meta: $xi');
      }
    }
    name = ename.toLowerCase();
    value = xi.innerText.trim();
    for (final xa in xi.attributes) {
      final name = xa.name.local.toLowerCase();
      attributes[name] = xa.value.trim();
    }
  }

  static List<Xitem> parse(XmlElement xe) => [
    ...xe.children.whereType<XmlElement>().map((x) => Xitem(x)),
  ];

  @override
  String toString() => 'Xitem(name: $name, value: $value attr: $attributes)';
}

extension XGetItem on Iterable<Xitem> {
  Xitem? find({required String name, String? scheme}) => firstWhereOrNull((x) {
    if (scheme != null) {
      return x.name == name && x.attributes['scheme'] == scheme;
    }
    return x.name == name;
  });
  Iterable<Xitem> findAll({required String name}) =>
      where((x) => x.name == name);
}
