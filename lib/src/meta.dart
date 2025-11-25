// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

import 'utils.dart';

class Xitem {
  late final String name;
  late final String value;
  final Map<String, String> attibutes = {};
  Xitem(XmlElement xi) {
    final xname = xi.name.local.toLowerCase();
    if (xname == 'meta') {
      name = xi.attributes.find('name')!.value.toLowerCase();
      value = xi.attributes.find('content')!.value;
    } else {
      name = xname.toLowerCase();
      value = xi.innerText;
      for (final xa in xi.attributes) {
        final name = xa.name.local.toLowerCase();
        final value = xa.value;
        attibutes[name] = value;
      }
    }
  }

  static List<Xitem> parse(XmlElement xe) => [
    ...xe.children.whereType<XmlElement>().map((x) => Xitem(x)),
  ];
}

extension XGetItem on Iterable<Xitem> {
  Xitem? find(String name) => firstWhereOrNull((x) => x.name == name);
}

