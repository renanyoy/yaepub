// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:xml/xml.dart';

class Xnav {
  String label;
  String href;
  List<Xnav> children;
  Xnav({required this.label, required this.href, required this.children});

  static List<Xnav> from({required XmlElement xelem}) {
    List<Xnav> nav = [];
    for (final xe in xelem.children.whereType<XmlElement>()) {
      final name = xe.name.local.toLowerCase();
      if (name == 'li') {
        nav.add(fromLi(xe));
      } else if (name == 'navpoint') {
        nav.add(fromNavPoint(xe));
      }
    }
    return nav;
  }

  static Xnav fromLi(XmlElement xe) {
    // TODO: yop!
  }

  static Xnav fromNavPoint(XmlElement xe) {
    final xlabel = xe.findElements('navLabel').firstOrNull;
    final xcontent = xe.findElements('content').firstOrNull;
    final xnavpoint = xe.findElements('navPoint').firstOrNull;
    final label =
        xlabel?.firstElementChild?.value ?? xlabel?.innerText ?? 'no name';
    final href = xcontent?.innerText.toLowerCase() ?? '';
    final children = xnavpoint != null ? Xnav.from(xelem: xnavpoint) : null;
    return Xnav(label: label, href: href, children: children ?? []);
  }
}
