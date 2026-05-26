import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sample_data.dart';
import '../../models/analytics_models.dart';
import '../../models/history_entry.dart';
import '../../services/analytics_service.dart';
import '../../services/takeout_parser.dart';

final analyticsServiceProvider = Provider((ref) => AnalyticsService());

final historyControllerProvider =
    StateNotifierProvider<HistoryController, HistoryState>((ref) {
  return HistoryController(ref.watch(analyticsServiceProvider));
});

final filteredEntriesProvider = Provider<List<HistoryEntry>>((ref) {
  final state = ref.watch(historyControllerProvider);
  final service = ref.watch(analyticsServiceProvider);
  return service.filter(
    state.entries,
    query: state.query,
    genre: state.genre,
    platform: state.platform,
    start: state.start,
    end: state.end,
  );
});

final analyticsSnapshotProvider = Provider<AnalyticsSnapshot>((ref) {
  final service = ref.watch(analyticsServiceProvider);
  return service.build(ref.watch(filteredEntriesProvider));
});

final topVideosProvider = Provider<List<TopVideoItem>>((ref) {
  final service = ref.watch(analyticsServiceProvider);
  return service.topVideos(ref.watch(filteredEntriesProvider));
});

class HistoryState {
  const HistoryState({
    required this.entries,
    this.query = '',
    this.genre = '',
    this.platform = PlatformFilter.all,
    this.start,
    this.end,
    this.loading = false,
    this.error,
    this.recentSearches = const [],
  });

  final List<HistoryEntry> entries;
  final String query;
  final String genre;
  final PlatformFilter platform;
  final DateTime? start;
  final DateTime? end;
  final bool loading;
  final String? error;
  final List<String> recentSearches;

  HistoryState copyWith({
    List<HistoryEntry>? entries,
    String? query,
    String? genre,
    PlatformFilter? platform,
    DateTime? start,
    DateTime? end,
    bool clearDates = false,
    bool? loading,
    String? error,
    bool clearError = false,
    List<String>? recentSearches,
  }) {
    return HistoryState(
      entries: entries ?? this.entries,
      query: query ?? this.query,
      genre: genre ?? this.genre,
      platform: platform ?? this.platform,
      start: clearDates ? null : start ?? this.start,
      end: clearDates ? null : end ?? this.end,
      loading: loading ?? this.loading,
      error: clearError ? null : error ?? this.error,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}

class HistoryController extends StateNotifier<HistoryState> {
  HistoryController(this._service)
      : super(HistoryState(entries: sampleEntries));

  final AnalyticsService _service;

  Future<void> importJson() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );
      if (result == null || result.files.single.bytes == null) {
        state = state.copyWith(loading: false);
        return;
      }
      final source = utf8.decode(result.files.single.bytes!);
      state =
          state.copyWith(entries: TakeoutParser.parse(source), loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  void importRawJson(String source) {
    state = state.copyWith(loading: true, clearError: true);
    try {
      state =
          state.copyWith(entries: TakeoutParser.parse(source), loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  void setQuery(String value) {
    final trimmed = value.trim();
    final recent = trimmed.isEmpty
        ? state.recentSearches
        : [trimmed, ...state.recentSearches.where((item) => item != trimmed)]
            .take(5)
            .toList();
    state = state.copyWith(query: value, recentSearches: recent);
  }

  void setGenre(String value) => state = state.copyWith(genre: value);
  void setPlatform(PlatformFilter value) =>
      state = state.copyWith(platform: value);

  void setPreset(DatePreset preset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (preset) {
      case DatePreset.today:
        _setRange(today, today.add(const Duration(days: 1)));
      case DatePreset.yesterday:
        _setRange(today.subtract(const Duration(days: 1)), today);
      case DatePreset.sevenDays:
        _setRange(now.subtract(const Duration(days: 7)), now);
      case DatePreset.thirtyDays:
        _setRange(now.subtract(const Duration(days: 30)), now);
      case DatePreset.threeMonths:
        _setRange(DateTime(now.year, now.month - 3, now.day), now);
      case DatePreset.sixMonths:
        _setRange(DateTime(now.year, now.month - 6, now.day), now);
      case DatePreset.year:
        _setRange(DateTime(now.year - 1, now.month, now.day), now);
      case DatePreset.custom:
        state = state.copyWith(clearDates: true);
    }
  }

  void _setRange(DateTime start, DateTime end) {
    _service.build(state.entries);
    state = state.copyWith(start: start, end: end);
  }
}
