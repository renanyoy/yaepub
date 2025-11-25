// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:xml/xml.dart';
import 'package:yaepub/src/nav.dart';

import 'package:yaepub/src/utils.dart';

import 'file.dart';
import 'meta.dart';

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
class Book {
  late String rootFilename;
  String get rootFolder => directoryFromFile(path: rootFilename);
  late Version version;
  Archive archive;
  Map<String, Bfile> files = {}; // <href,file>
  Map<String, Mfile> manifest = {}; // <id,file>
  List<Xitem> meta = [];
  List<Xitem> spine = [];
  List<Xitem> guide = [];
  List<Xnav> navigation = [];
  String tocId = 'toc.ncx';
  Mfile? get cover => manifest[meta.find('cover')?.value ?? 'cover'];
  Mfile? get toc => manifest[tocId];

  Book({required this.archive}) {
    files = Bfile.from(archive: archive);
    rootFilename = _getRootFile(files: files);
    final pfile = files.get(rootFilename);
    if (pfile == null) throw Berror('package $rootFilename not found');
    readPackage(pfile);
    if (toc != null) readToc(toc!);
  }

  void readToc(Bfile file) {
    const ns = 'http://www.daisy.org/z3986/2005/ncx/';
    final xdoc = file.asXdoc;
    final xncx = xdoc.findAllElements('ncx', namespace: ns).firstOrNull;
    if (xncx == null) return;
    final xnav = xncx.findElements('navMap', namespace: ns).firstOrNull;
    if (xnav != null) {
      navigation = Xnav.from(xelem: xnav);
    }
  }

  void readPackage(Bfile file) {
    const ns = 'http://www.idpf.org/2007/opf';
    final xdoc = file.asXdoc;
    final xpackage = xdoc.findElements('package', namespace: ns).firstOrNull;
    if (xpackage == null) throw Berror('broken package');
    version = Version.from(string: xpackage.getAttribute('version') ?? '');
    if (version == .epub1) throw Berror('epub $version unimplemented');
    final xmeta = xpackage.findElements('metadata', namespace: ns).firstOrNull;
    if (xmeta == null) throw Berror('metadata missing');
    final xmanifest = xpackage
        .findElements('manifest', namespace: ns)
        .firstOrNull;
    if (xmanifest == null) throw Berror('manifest missing');
    final xspine = xpackage.findElements('spine', namespace: ns).firstOrNull;
    if (xspine == null) throw Berror('spine missing');
    final xguide = xpackage.findElements('guide', namespace: ns).firstOrNull;
    meta = Xitem.parse(xmeta);
    for (final xman in Xitem.parse(xmanifest)) {
      final id = xman.attibutes['id'] ?? '';
      final href = decodeUri(xman.attibutes['href'] ?? '').toLowerCase();
      if (href.isEmpty || id.isEmpty) continue;
      final mimeType = xman.attibutes['media-type'];
      if (files.containsKey(href)) {
        final mf = Mfile(file: files[href]!, id: id, mimeType: mimeType);
        files[href] = mf;
        manifest[id] = mf;
      } else {
        print('minssing $href');
      }
    }
    tocId = xspine.attributes.find('toc')?.value ?? 'toc.ncx';
    spine = Xitem.parse(xspine);
    if (xguide != null) {
      guide = Xitem.parse(xguide);
    }
  }

  factory Book.from({required Uint8List bytes}) {
    final archive = ZipDecoder().decodeBytes(bytes);
    return Book(archive: archive);
  }

  static String _getRootFile({required Map<String, Bfile> files}) {
    final fcontainer = files.get('META-INF/container.xml');
    if (fcontainer == null) throw Berror('no META-INF/container.xml');
    final container = xdocFromBytes(fcontainer.content)
        .findElements(
          'container',
          namespace: 'urn:oasis:names:tc:opendocument:xmlns:container',
        )
        .firstOrNull;
    if (container == null) return '';
    final rootfile = container
        .findElements('rootfiles')
        .firstOrNull
        ?.findElements('rootfile')
        .firstOrNull;
    return rootfile?.getAttribute('full-path') ?? '';
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
