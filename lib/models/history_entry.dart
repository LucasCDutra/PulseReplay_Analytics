import 'package:json_annotation/json_annotation.dart';

part 'history_entry.g.dart';

@JsonSerializable()
class HistoryEntry {
  const HistoryEntry({
    required this.header,
    required this.title,
    required this.titleUrl,
    required this.subtitles,
    required this.time,
    required this.products,
    required this.activityControls,
  });

  final String header;
  final String title;
  final String? titleUrl;
  final List<EntrySubtitle> subtitles;
  final DateTime time;
  final List<String> products;
  final List<String> activityControls;

  bool get isMusic => header.toLowerCase().contains('music');
  String get cleanTitle => title
      .replaceFirst(RegExp(r'^Watched\s+', caseSensitive: false), '')
      .trim();
  String get creator => subtitles.isEmpty
      ? 'Unknown'
      : subtitles.first.name.replaceAll(' - Topic', '');
  String get videoId {
    final url = titleUrl ?? '';
    final uri = Uri.tryParse(url);
    return uri?.queryParameters['v'] ?? '';
  }

  factory HistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$HistoryEntryFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryEntryToJson(this);
}

@JsonSerializable()
class EntrySubtitle {
  const EntrySubtitle({required this.name, this.url});

  final String name;
  final String? url;

  factory EntrySubtitle.fromJson(Map<String, dynamic> json) =>
      _$EntrySubtitleFromJson(json);
  Map<String, dynamic> toJson() => _$EntrySubtitleToJson(this);
}
