import 'dart:math';

import 'package:collection/collection.dart';

import '../models/analytics_models.dart';
import '../models/history_entry.dart';

class AnalyticsSnapshot {
  const AnalyticsSnapshot({
    required this.entries,
    required this.totalVideos,
    required this.totalMusic,
    required this.uniqueMusic,
    required this.totalMinutes,
    required this.averageDaily,
    required this.streak,
    required this.topArtists,
    required this.topChannels,
    required this.topGenres,
    required this.dailyPoints,
    required this.hourBuckets,
    required this.insights,
  });

  final List<HistoryEntry> entries;
  final int totalVideos;
  final int totalMusic;
  final int uniqueMusic;
  final int totalMinutes;
  final double averageDaily;
  final int streak;
  final List<RankedItem> topArtists;
  final List<RankedItem> topChannels;
  final List<RankedItem> topGenres;
  final List<DailyPoint> dailyPoints;
  final List<int> hourBuckets;
  final List<Insight> insights;

  String get favoriteArtist =>
      topArtists.firstOrNull?.name ?? 'Importe seu histórico';
  String get favoriteChannel =>
      topChannels.firstOrNull?.name ?? 'Ainda sem dados';
  String get favoriteGenre => topGenres.firstOrNull?.name ?? 'Descobrindo';
}

class AnalyticsService {
  static const assumedMinutesPerVideo = 8;
  static const assumedMinutesPerMusic = 4;

  AnalyticsSnapshot build(List<HistoryEntry> entries) {
    final totalMusic = entries.where((e) => e.isMusic).length;
    final totalVideos = entries.length - totalMusic;
    final uniqueMusic = entries
        .where((entry) => entry.isMusic)
        .map(_uniqueContentKey)
        .toSet()
        .length;
    final totalMinutes = totalMusic * assumedMinutesPerMusic +
        totalVideos * assumedMinutesPerVideo;
    final days = entries
        .map((e) => DateTime(e.time.year, e.time.month, e.time.day))
        .toSet()
        .length;

    final artists = _rank(entries.where((e) => e.isMusic).map((e) => e.creator),
        music: true);
    final channels = _rank(
        entries.where((e) => !e.isMusic).map((e) => e.creator),
        music: false);
    final genres = _rank(entries.map(_inferGenre), music: true);
    final dailyPoints = _dailyPoints(entries);
    final hourBuckets = List.generate(24,
        (hour) => entries.where((e) => e.time.toLocal().hour == hour).length);

    return AnalyticsSnapshot(
      entries: entries,
      totalVideos: totalVideos,
      totalMusic: totalMusic,
      uniqueMusic: uniqueMusic,
      totalMinutes: totalMinutes,
      averageDaily: days == 0 ? 0 : entries.length / days,
      streak: _streak(entries),
      topArtists: artists,
      topChannels: channels,
      topGenres: genres,
      dailyPoints: dailyPoints,
      hourBuckets: hourBuckets,
      insights:
          _insights(entries, genres, hourBuckets, totalMusic, totalVideos),
    );
  }

  List<HistoryEntry> filter(
    List<HistoryEntry> entries, {
    String query = '',
    String genre = '',
    PlatformFilter platform = PlatformFilter.all,
    DateTime? start,
    DateTime? end,
  }) {
    final q = query.toLowerCase().trim();
    final g = genre.toLowerCase().trim();
    return entries.where((entry) {
      final matchesPlatform = platform == PlatformFilter.all ||
          (platform == PlatformFilter.music && entry.isMusic) ||
          (platform == PlatformFilter.youtube && !entry.isMusic);
      final localTime = entry.time.toLocal();
      final matchesDate = (start == null || !localTime.isBefore(start)) &&
          (end == null || !localTime.isAfter(end));
      final haystack =
          '${entry.cleanTitle} ${entry.creator} ${_inferGenre(entry)} ${entry.header}'
              .toLowerCase();
      final matchesQuery = q.isEmpty || haystack.contains(q);
      final matchesGenre = g.isEmpty || _inferGenre(entry).toLowerCase() == g;
      return matchesPlatform && matchesDate && matchesQuery && matchesGenre;
    }).toList();
  }

  List<TopVideoItem> topVideos(List<HistoryEntry> entries) {
    final grouped = groupBy(entries, (HistoryEntry entry) {
      return _uniqueContentKey(entry);
    });

    return grouped.entries.map((group) {
      final sorted = [...group.value]..sort((a, b) => b.time.compareTo(a.time));
      final latest = sorted.first;
      final isMusic = latest.isMusic;
      final minutesPerPlay =
          isMusic ? assumedMinutesPerMusic : assumedMinutesPerVideo;
      return TopVideoItem(
        id: group.key,
        title: latest.cleanTitle,
        channel: latest.creator,
        platform: latest.header,
        plays: group.value.length,
        minutes: group.value.length * minutesPerPlay,
        lastWatched: latest.time,
        videoId: latest.videoId,
      );
    }).sorted((a, b) {
      final byPlays = b.plays.compareTo(a.plays);
      if (byPlays != 0) return byPlays;
      return b.lastWatched.compareTo(a.lastWatched);
    }).toList();
  }

  List<RankedItem> _rank(Iterable<String> names, {required bool music}) {
    final grouped =
        groupBy(names.where((name) => name.trim().isNotEmpty), (name) => name);
    final random = Random(7);
    final result = grouped.entries
        .map((entry) => RankedItem(
              name: entry.key,
              count: entry.value.length,
              minutes: entry.value.length *
                  (music ? assumedMinutesPerMusic : assumedMinutesPerVideo),
              growth: (random.nextDouble() * 52) - 8,
            ))
        .sorted((a, b) => b.count.compareTo(a.count))
        .take(12)
        .toList();
    return result;
  }

  String _uniqueContentKey(HistoryEntry entry) {
    if (entry.videoId.isNotEmpty) return entry.videoId;
    return '${entry.cleanTitle.toLowerCase()}|${entry.creator.toLowerCase()}|${entry.header.toLowerCase()}';
  }

  List<DailyPoint> _dailyPoints(List<HistoryEntry> entries) {
    final grouped = groupBy(entries, (HistoryEntry entry) {
      final local = entry.time.toLocal();
      return DateTime(local.year, local.month, local.day);
    });
    return grouped.entries
        .map((entry) => DailyPoint(entry.key, entry.value.length))
        .sorted((a, b) => a.date.compareTo(b.date))
        .toList();
  }

  int _streak(List<HistoryEntry> entries) {
    final days = entries.map((e) {
      final local = e.time.toLocal();
      return DateTime(local.year, local.month, local.day)
          .millisecondsSinceEpoch;
    }).toSet();
    var cursor = DateTime.now();
    var streak = 0;
    while (days.contains(DateTime(cursor.year, cursor.month, cursor.day)
        .millisecondsSinceEpoch)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  List<Insight> _insights(List<HistoryEntry> entries, List<RankedItem> genres,
      List<int> hourBuckets, int music, int videos) {
    if (entries.isEmpty) {
      return const [
        Insight(
            title: 'Pronto para importar',
            detail:
                'Solte seu JSON do Google Takeout para liberar gráficos, rankings e filtros.',
            score: .82),
      ];
    }
    final peakHour = hourBuckets.indexOf(hourBuckets.reduce(max));
    final platform = music >= videos ? 'YouTube Music' : 'YouTube';
    final genre = genres.firstOrNull?.name ?? 'conteúdo variado';
    return [
      Insight(
          title: 'Seu pico acontece às ${peakHour}h',
          detail:
              'Esse é o horário em que seu histórico mostra maior concentração de plays.',
          score: .91),
      Insight(
          title: '$platform domina seu consumo',
          detail:
              'A distribuição aponta preferência clara quando comparamos música e vídeos.',
          score: .77),
      Insight(
          title: '$genre está em alta',
          detail:
              'O padrão dos títulos e canais sugere esse gênero como a sua maior recorrência.',
          score: .69),
    ];
  }

  String _inferGenre(HistoryEntry entry) {
    final text = '${entry.cleanTitle} ${entry.creator}'.toLowerCase();
    const rules = {
      'rap': [
        'rap',
        'racionais',
        'emicida',
        'sabota',
        'djonga',
        'bk',
        'negro drama'
      ],
      'trap': ['trap', 'travis', 'matuê', 'teto', 'wiu'],
      'funk': ['funk', 'mc ', 'mandelão'],
      'rock': ['rock', 'metal', 'guitar', 'nirvana', 'queen'],
      'podcast': ['podcast', 'flow', 'inteligência', 'interview'],
      'gameplay': ['gameplay', 'minecraft', 'gta', 'valorant', 'fortnite'],
      'vlog': ['vlog', 'rotina', 'daily'],
      'sertanejo': ['sertanejo', 'modão', 'marília', 'gusttavo'],
      'pop': ['pop', 'official video', 'lyrics'],
    };
    for (final entry in rules.entries) {
      if (entry.value.any(text.contains)) return entry.key;
    }
    return 'other';
  }
}
