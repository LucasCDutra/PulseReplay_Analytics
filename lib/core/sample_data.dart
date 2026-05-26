import '../models/history_entry.dart';

final sampleEntries = <HistoryEntry>[
  HistoryEntry(
    header: 'YouTube Music',
    title: 'Watched Negro Drama',
    titleUrl: 'https://music.youtube.com/watch?v=o50J2xg8-sU',
    subtitles: const [EntrySubtitle(name: "Racionais MC's - Topic")],
    time: DateTime.now().subtract(const Duration(hours: 2)),
    products: const ['YouTube'],
    activityControls: const ['YouTube watch history'],
  ),
  HistoryEntry(
    header: 'YouTube',
    title: 'Watched Flutter Web performance dashboard',
    titleUrl: 'https://www.youtube.com/watch?v=flutter',
    subtitles: const [EntrySubtitle(name: 'Design Code')],
    time: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    products: const ['YouTube'],
    activityControls: const ['YouTube watch history'],
  ),
  HistoryEntry(
    header: 'YouTube Music',
    title: 'Watched AmarElo',
    titleUrl: 'https://music.youtube.com/watch?v=amarelo',
    subtitles: const [EntrySubtitle(name: 'Emicida - Topic')],
    time: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
    products: const ['YouTube'],
    activityControls: const ['YouTube watch history'],
  ),
  HistoryEntry(
    header: 'YouTube',
    title: 'Watched Valorant gameplay highlights',
    titleUrl: 'https://www.youtube.com/watch?v=game',
    subtitles: const [EntrySubtitle(name: 'Arena Plays')],
    time: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
    products: const ['YouTube'],
    activityControls: const ['YouTube watch history'],
  ),
];
