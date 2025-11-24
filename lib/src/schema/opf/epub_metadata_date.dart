import 'package:xml/xml.dart';

class EpubMetadataDate {
  final String? date;
  final String? event;

  const EpubMetadataDate({
    this.date,
    this.event,
  });

  @override
  int get hashCode => date.hashCode ^ event.hashCode;

  @override
  bool operator ==(covariant EpubMetadataDate other) {
    if (identical(this, other)) return true;
    return other.date == date && other.event == event;
  }

  factory EpubMetadataDate.fromXml(XmlElement metadataDateNode) {
    String? event, date;
    var eventAttribute = metadataDateNode.getAttribute('event',
        namespace: metadataDateNode.name.namespaceUri);
    if (eventAttribute != null && eventAttribute.isNotEmpty) {
      event = eventAttribute;
    }
    date = metadataDateNode.innerText;
    return EpubMetadataDate(
      date: date,
      event: event,
    );
  }
}
