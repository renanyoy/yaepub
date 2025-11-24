import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

import 'epub_metadata_contributor.dart';
import 'epub_metadata_creator.dart';
import 'epub_metadata_date.dart';
import 'epub_metadata_identifier.dart';
import 'epub_metadata_meta.dart';
import 'epub_version.dart';

class EpubMetadata {
  final List<String> titles;
  final List<EpubMetadataCreator> creators;
  final List<String> subjects;
  final String? description;
  final List<String> publishers;
  final List<EpubMetadataContributor> contributors;
  final List<EpubMetadataDate> dates;
  final List<String> types;
  final List<String> formats;
  final List<EpubMetadataIdentifier> identifiers;
  final List<String> sources;
  final List<String> languages;
  final List<String> relations;
  final List<String> coverages;
  final List<String> rights;
  final List<EpubMetadataMeta> metaItems;

  const EpubMetadata({
    this.titles = const <String>[],
    this.creators = const <EpubMetadataCreator>[],
    this.subjects = const <String>[],
    this.description,
    this.publishers = const <String>[],
    this.contributors = const <EpubMetadataContributor>[],
    this.dates = const <EpubMetadataDate>[],
    this.types = const <String>[],
    this.formats = const <String>[],
    this.identifiers = const <EpubMetadataIdentifier>[],
    this.sources = const <String>[],
    this.languages = const <String>[],
    this.relations = const <String>[],
    this.coverages = const <String>[],
    this.rights = const <String>[],
    this.metaItems = const <EpubMetadataMeta>[],
  });

  @override
  int get hashCode {
    final hash = const DeepCollectionEquality().hash;

    return hash(titles) ^
        hash(creators) ^
        hash(subjects) ^
        description.hashCode ^
        hash(publishers) ^
        hash(contributors) ^
        hash(dates) ^
        hash(types) ^
        hash(formats) ^
        hash(identifiers) ^
        hash(sources) ^
        hash(languages) ^
        hash(relations) ^
        hash(coverages) ^
        hash(rights) ^
        hash(metaItems);
  }

  @override
  bool operator ==(covariant EpubMetadata other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.titles, titles) &&
        listEquals(other.creators, creators) &&
        listEquals(other.subjects, subjects) &&
        other.description == description &&
        listEquals(other.publishers, publishers) &&
        listEquals(other.contributors, contributors) &&
        listEquals(other.dates, dates) &&
        listEquals(other.types, types) &&
        listEquals(other.formats, formats) &&
        listEquals(other.identifiers, identifiers) &&
        listEquals(other.sources, sources) &&
        listEquals(other.languages, languages) &&
        listEquals(other.relations, relations) &&
        listEquals(other.coverages, coverages) &&
        listEquals(other.rights, rights) &&
        listEquals(other.metaItems, metaItems);
  }

  factory EpubMetadata.fromXml(
    XmlElement metadataNode,
    EpubVersion? epubVersion,
  ) {
    String? description;
    final titles = <String>[];
    final creators = <EpubMetadataCreator>[];
    final subjects = <String>[];
    final publishers = <String>[];
    final contributors = <EpubMetadataContributor>[];
    final dates = <EpubMetadataDate>[];
    final types = <String>[];
    final formats = <String>[];
    final identifiers = <EpubMetadataIdentifier>[];
    final sources = <String>[];
    final languages = <String>[];
    final relations = <String>[];
    final coverages = <String>[];
    final rights = <String>[];
    final metaItems = <EpubMetadataMeta>[];
    metadataNode.children.whereType<XmlElement>().forEach(
      (XmlElement metadataItemNode) {
        final innerText = metadataItemNode.innerText;

        return switch (metadataItemNode.name.local.toLowerCase()) {
          'title' => titles.add(innerText),
          'creator' =>
            creators.add(EpubMetadataCreator.fromXml(metadataItemNode)),
          'subject' => subjects.add(innerText),
          'description' => description = innerText,
          'publisher' => publishers.add(innerText),
          'contributor' =>
            contributors.add(EpubMetadataContributor.fromXml(metadataItemNode)),
          'date' => dates.add(EpubMetadataDate.fromXml(metadataItemNode)),
          'type' => types.add(innerText),
          'format' => formats.add(innerText),
          'identifier' =>
            identifiers.add(EpubMetadataIdentifier.fromXml(metadataItemNode)),
          'source' => sources.add(innerText),
          'language' => languages.add(innerText),
          'relation' => relations.add(innerText),
          'coverage' => coverages.add(innerText),
          'rights' => rights.add(innerText),
          'meta' when epubVersion == EpubVersion.epub2 =>
            metaItems.add(EpubMetadataMeta.fromXmlVersion2(metadataItemNode)),
          'meta' when epubVersion == EpubVersion.epub3 =>
            metaItems.add(EpubMetadataMeta.fromXmlVersion3(metadataItemNode)),
          _ => null,
        };
      },
    );
    return EpubMetadata(
      titles: titles,
      creators: creators,
      subjects: subjects,
      description: description,
      publishers: publishers,
      contributors: contributors,
      dates: dates,
      types: types,
      formats: formats,
      identifiers: identifiers,
      sources: sources,
      languages: languages,
      relations: relations,
      coverages: coverages,
      rights: rights,
      metaItems: metaItems,
    );
  }
}
