import 'package:xml/xml.dart';
import 'package:yaepub/src/utils.dart';

/// Represents a navigation item in the EPUB's table of contents.
class Xnav {
  /// The label of the navigation item.
  String label;

  /// The ID of the navigation item.
  String id;

  /// The href of the navigation item.
  String href;

  /// The children of the navigation item.
  List<Xnav> children;

  /// Creates a new Xnav instance.
  Xnav({
    required this.label,
    required this.id,
    required this.href,
    required this.children,
  });

  /// Parses a list of Xnav instances from an XML element.
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

  /// Parses an Xnav instance from an 'li' XML element.
  static Xnav fromLi(XmlElement xe) {
    final x =
        xe.findElements('a').firstOrNull ?? xe.findElements('span').firstOrNull;
    final xol = xe.findElements('ol').firstOrNull;
    final label = x?.innerText ?? x?.innerText ?? 'no name';
    final id = x?.attributes.find('id')?.value ?? '';
    final href = decodeUri(
      x?.attributes.find('href')?.value ?? '',
    ).toLowerCase();
    final children = xol != null ? Xnav.from(xelem: xol) : <Xnav>[];
    return Xnav(label: label, id: id, href: href, children: children);
  }

  /// Parses an Xnav instance from a 'navPoint' XML element.
  static Xnav fromNavPoint(XmlElement xe) {
    final xlabel = xe.findElements('navLabel').firstOrNull;
    final xcontent = xe.findElements('content').firstOrNull;
    final label =
        xlabel?.firstElementChild?.value ?? xlabel?.innerText ?? 'no name';
    final id = xcontent?.attributes.find('id')?.value ?? '';
    final href = decodeUri(
      xcontent?.attributes.find('src')?.value ?? '',
    ).toLowerCase();
    final children = Xnav.from(xelem: xe);
    return Xnav(label: label, id: id, href: href, children: children);
  }
}
