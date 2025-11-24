import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:xml/xml.dart';
import 'package:yaepub/src/utils.dart';

import 'epub_guide.dart';
import 'epub_manifest.dart';
import 'epub_metadata.dart';
import 'epub_spine.dart';
import 'epub_version.dart';

class EpubPackage {
  final EpubVersion version;
  final EpubMetadata metadata;
  final EpubManifest manifest;
  final EpubSpine? spine;
  final EpubGuide? guide;

  const EpubPackage({
    required this.version,
    required this.metadata,
    required this.manifest,
    this.spine,
    this.guide,
  });

  factory EpubPackage.from({required Archive archive}) {
    final ns = 'http://www.idpf.org/2007/opf';
    final epubRootFilePath = rootFile(archive: archive);
    var rootFileEntry = archive.find(epubRootFilePath);
    if (rootFileEntry == null) {
      throw Exception('EPUB parsing error: root file not found in archive.');
    }
    final container = rootFileEntry.xml;
    final packageNode = container
        .findElements('package', namespace: ns)
        .firstOrNull;
    final versionText = packageNode?.getAttribute('version') ?? '';
    final version = EpubVersion.from(string: versionText);
    if (version == null) {
      throw Exception('Unsupported EPUB version $versionText');
    }
    var metadataNode = packageNode!
        .findElements('metadata', namespace: ns)
        .firstOrNull;
    if (metadataNode == null) {
      throw Exception('EPUB parsing error: metadata not found in the package.');
    }
    final metadata = EpubMetadata.fromXml(metadataNode, version);

    final manifestNode = packageNode
        .findElements('manifest', namespace: ns)
        .firstOrNull;
    if (manifestNode == null) {
      throw Exception('EPUB parsing error: manifest not found in the package.');
    }
    final manifest = EpubManifest.fromXml(manifestNode);

    final spineNode = packageNode.
        .findElements('spine', namespace: ns)
        .firstOrNull;
    if (spineNode == null) {
      throw Exception('EPUB parsing error: spine not found in the package.');
    }
    final spine = EpubSpine.fromXml(spineNode);

    final guideNode = packageNode
        .findElements('guide', namespace: ns)
        .firstOrNull;
    final guide = guideNode != null ? EpubGuide.fromXml(guideNode) : null;

    return EpubPackage(
      version: version,
      metadata: metadata,
      manifest: manifest,
      spine: spine,
      guide: guide,
    );
  }

  static String rootFile({required Archive archive}) {
    final container = archive.find('META-INF/container.xml');
    if (container == null) {
      throw Exception('META-INF/container.xml not found.');
    }
    final containerDocument = container.xml;
    final packageElement = containerDocument
        .findAllElements(
          'container',
          namespace: 'urn:oasis:names:tc:opendocument:xmlns:container',
        )
        .whereType<XmlElement>()
        .firstOrNull;
    if (packageElement == null) {
      throw Exception('Invalid epub container');
    }
    final rootFileElement = packageElement.descendants
        .whereType<XmlElement>()
        .firstWhereOrNull((e) => e.name.local == 'rootfile');

    return rootFileElement?.getAttribute('full-path') ?? '';
  }

  /*

  String get epubContentDirectoryPath =>
      ZipPath.getDirectoryPath(epubRootFilePath);


  */
}
