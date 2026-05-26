class RankedItem {
  const RankedItem({
    required this.name,
    required this.count,
    required this.minutes,
    required this.growth,
  });

  final String name;
  final int count;
  final int minutes;
  final double growth;
}

class TopVideoItem {
  const TopVideoItem({
    required this.id,
    required this.title,
    required this.channel,
    required this.platform,
    required this.plays,
    required this.minutes,
    required this.lastWatched,
    required this.videoId,
  });

  final String id;
  final String title;
  final String channel;
  final String platform;
  final int plays;
  final int minutes;
  final DateTime lastWatched;
  final String videoId;

  bool get isMusic => platform.toLowerCase().contains('music');
}

class DailyPoint {
  const DailyPoint(this.date, this.count);
  final DateTime date;
  final int count;
}

class Insight {
  const Insight({
    required this.title,
    required this.detail,
    required this.score,
  });

  final String title;
  final String detail;
  final double score;
}

enum PlatformFilter { all, youtube, music }

enum DatePreset {
  today,
  yesterday,
  sevenDays,
  thirtyDays,
  threeMonths,
  sixMonths,
  year,
  custom,
}
