import '../../domain/entities/installed_app_entity.dart';

class InstalledAppsState {
  const InstalledAppsState({required this.apps, this.searchQuery = ''});

  final List<InstalledAppEntity> apps;
  final String searchQuery;

  List<InstalledAppEntity> get filteredApps {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return apps;
    return apps.where((app) => app.name.toLowerCase().contains(query) || app.packageName.toLowerCase().contains(query)).toList();
  }

  InstalledAppsState copyWith({List<InstalledAppEntity>? apps, String? searchQuery}) {
    return InstalledAppsState(apps: apps ?? this.apps, searchQuery: searchQuery ?? this.searchQuery);
  }
}
