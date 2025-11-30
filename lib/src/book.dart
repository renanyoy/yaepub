// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:xml/xml.dart';
import 'package:yaepub/src/nav.dart';

import 'package:yaepub/src/utils.dart';

import 'file.dart';
import 'meta.dart';
import 'misc.dart';
import 'spine.dart';

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
class Book {
  final String debugRef;
  final Archive _archive;
  late final String _rootFilename;
  String get _rootFolder => directoryFromFile(path: _rootFilename);
  late final Version version;
  Map<String, Bfile> files = {}; // <href,file>
  Map<String, Mfile> manifest = {}; // <id,file>
  List<Xitem> meta = [];
  List<Spine> spine = [];
  List<Xitem> guide = [];
  List<Xnav> navigation = [];
  String _tocId = 'toc.ncx';
  Mfile? get _toc => manifest[_tocId];
  String get author => meta.find(name: 'creator')?.value ?? 'Unknwown';
  String get title => meta.find(name: 'title')?.value ?? 'No name';
  String? get publisher => meta.find(name: 'publisher')?.value;
  String? get subject => meta.find(name: 'subject')?.value;
  String? get description => meta
      .find(name: 'description')
      ?.value
      .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
      .replaceAll('\r\n', ' ')
      .replaceAll('\r', ' ')
      .replaceAll('\n', ' ')
      .replaceAll('    ', ' ')
      .replaceAll('   ', ' ')
      .replaceAll('  ', ' ')
      .trim();
  String? get language => meta.find(name: 'language')?.value;
  DateTime? get date => DateTime.tryParse(meta.find(name: 'date')?.value ?? '');
  String get id {
    final text = meta
        .where((xi) => xi.value.isNotEmpty)
        .fold(['yaepub'], (m, xi) => [...m, xi.value])
        .join('.');
    return md5.convert(utf8.encode(text)).toString();
  }

  String? get isbn => meta
      .findAll(name: 'identifier')
      .firstWhereOrNull((i) => i.value.startsWith('978'))
      ?.value
      .replaceAll('-', '');
  String? get uuid => meta.find(name: 'identifier', scheme: 'uuid')?.value;
  Mfile? get cover =>
      manifest['cover-image'] ??
      (meta.find(name: 'cover') != null
          ? manifest[meta.find(name: 'cover')!.value]
          : null);
  String _rootCombine(String href) =>
      (combineHref(path: _rootFolder, href: decodeUri(href)).toLowerCase());
  Book({required Archive archive, this.debugRef = 'Book'})
    : _archive = archive {
    files = Bfile.from(archive: _archive);
    _rootFilename = _getRootFile(files: files);
    final pfile = files.get(_rootFilename);
    if (pfile == null) throw Berror('package $_rootFilename not found');
    _readPackage(pfile);
    if (_toc != null) _readToc(_toc!);
  }

  void _readToc(Bfile file) {
    const ns = 'http://www.daisy.org/z3986/2005/ncx/';
    final xdoc = file.asXdoc;
    final xncx = xdoc.findAllElements('ncx', namespace: ns).firstOrNull;
    if (xncx == null) return;
    final xnav = xncx.findElements('navMap', namespace: ns).firstOrNull;
    if (xnav != null) {
      navigation = Xnav.from(xelem: xnav);
    }
  }

  void _readPackage(Bfile file) {
    const ns = 'http://www.idpf.org/2007/opf';
    final xdoc = file.asXdoc;
    final xpackage = xdoc.findElements('package', namespace: ns).firstOrNull;
    if (xpackage == null) throw Berror('broken package');
    version = Version.from(string: xpackage.getAttribute('version') ?? '');
    //if (version == .epub1) throw Berror('epub $version unimplemented');
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
      String id = xman.attributes['id'] ?? '';
      if (xman.attributes['properties'] == 'cover-image') {
        // special case
        id = 'cover-image';
      }
      if (xman.attributes['href'] == null || id.isEmpty) continue;
      final href = _rootCombine(xman.attributes['href'] ?? '');
      final mimeType = xman.attributes['media-type'];
      if (files.containsKey(href)) {
        final mf = Mfile(file: files[href]!, id: id, mimeType: mimeType);
        files[href] = mf;
        manifest[id] = mf;
      } else {
        print('missing $debugRef($href)');
      }
    }
    _tocId = xspine.attributes.find('toc')?.value ?? 'toc.ncx';
    spine = [
      ...Xitem.parse(xspine).map((xi) {
        final id = xi.attributes['idref'];
        if (id == null) throw Berror('spine error, missing idref');
        final linear = xi.attributes['linear'] ?? 'yes';
        final file = manifest[id];
        if (file == null) throw Berror('spine error, file not found id:$id');
        return Spine(id: id, linear: linear, file: file);
      }),
    ];
    if (xguide != null) {
      guide = Xitem.parse(xguide);
    }
  }

  factory Book.from({required Uint8List bytes, String debugRef = 'Book.from'}) {
    final archive = ZipDecoder().decodeBytes(bytes);
    if (archive.files.isEmpty) {
      throw Berror('no files (broken epub+zip)');
    }
    return Book(archive: archive, debugRef: debugRef);
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
