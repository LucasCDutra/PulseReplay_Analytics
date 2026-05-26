part of 'history_entry.dart';

HistoryEntry _$HistoryEntryFromJson(Map<String, dynamic> json) => HistoryEntry(
      header: json['header'] as String? ?? 'YouTube',
      title: json['title'] as String? ?? 'Untitled',
      titleUrl: json['titleUrl'] as String?,
      subtitles: (json['subtitles'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(EntrySubtitle.fromJson)
          .toList(),
      time: DateTime.tryParse(json['time'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      products: (json['products'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      activityControls: (json['activityControls'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
    );

Map<String, dynamic> _$HistoryEntryToJson(HistoryEntry instance) =>
    <String, dynamic>{
      'header': instance.header,
      'title': instance.title,
      'titleUrl': instance.titleUrl,
      'subtitles': instance.subtitles.map((e) => e.toJson()).toList(),
      'time': instance.time.toIso8601String(),
      'products': instance.products,
      'activityControls': instance.activityControls,
    };

EntrySubtitle _$EntrySubtitleFromJson(Map<String, dynamic> json) =>
    EntrySubtitle(
      name: json['name'] as String? ?? 'Unknown',
      url: json['url'] as String?,
    );

Map<String, dynamic> _$EntrySubtitleToJson(EntrySubtitle instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };
