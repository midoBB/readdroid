import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:readeck/api_service.dart';
import 'package:readeck/bookmark_models.dart';

class BookmarksDrawer extends HookWidget {
  final ApiService apiService;
  final void Function(BookmarkQuery)? onQueryChanged;
  final BookmarkQuery? selectedQuery;
  const BookmarksDrawer({super.key, required this.apiService, this.onQueryChanged, this.selectedQuery});

  @override
  Widget build(BuildContext context) {
    final allCounts =
        useQuery(["counts"], apiService.getBookmarkCount);
    
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Bookmarks',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF23292D),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search,
                        color: Colors.cyanAccent, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _drawerItem(
              context,
              icon: Icons.library_books,
              label: 'All',
              count: allCounts.data?.total ?? 0,
              loading: allCounts.isLoading,
              selected: selectedQuery == null || (selectedQuery?.readStatus == null && selectedQuery?.isArchived != true && selectedQuery?.isMarked != true && selectedQuery?.type == null),
              onTap: () {
                onQueryChanged?.call(BookmarkQuery());
                Navigator.pop(context);
              },
            ),
            _drawerItem(
              context,
              icon: Icons.mark_email_unread,
              label: 'Unread',
              count: allCounts.data?.unread ?? 0,
              loading: allCounts.isLoading,
              selected: selectedQuery?.readStatus != null && selectedQuery!.readStatus!.contains("unread"),
              onTap: () {
                onQueryChanged?.call(BookmarkQuery(readStatus: ["unread"]));
                Navigator.pop(context);
              },
            ),
            _drawerItem(
              context,
              icon: Icons.archive,
              label: 'Archive',
              count: allCounts.data?.archived ?? 0,
              loading: allCounts.isLoading,
              selected: selectedQuery?.isArchived == true,
              onTap: () {
                onQueryChanged?.call(BookmarkQuery(isArchived: true));
                Navigator.pop(context);
              },
            ),
            _drawerItem(
              context,
              icon: Icons.favorite_border,
              label: 'Favorites',
              count: allCounts.data?.marked ?? 0,
              loading: allCounts.isLoading,
              selected: selectedQuery?.isMarked == true,
              onTap: () {
                onQueryChanged?.call(BookmarkQuery(isMarked: true));
                Navigator.pop(context);
              },
            ),
            _drawerItem(
              context,
              icon: Icons.article,
              label: 'Articles',
              count: allCounts.data?.byType['article'] ?? 0,
              loading: allCounts.isLoading,
              selected: selectedQuery?.type != null && selectedQuery!.type!.contains("article"),
              onTap: () {
                onQueryChanged?.call(BookmarkQuery(type: ["article"]));
                Navigator.pop(context);
              },
            ),
            _drawerItem(
              context,
              icon: Icons.ondemand_video,
              label: 'Videos',
              count: allCounts.data?.byType['video'] ?? 0,
              loading: allCounts.isLoading,
              selected: selectedQuery?.type != null && selectedQuery!.type!.contains("video"),
              onTap: () {
                onQueryChanged?.call(BookmarkQuery(type: ["video"]));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
  }
}

Widget _drawerItem(
  BuildContext context, {
  required IconData icon,
  required String label,
  int? count,
  bool loading = false,
  bool selected = false,
  VoidCallback? onTap,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: selected
        ? BoxDecoration(
            color: const Color(0xFF223238),
            borderRadius: BorderRadius.circular(8),
          )
        : null,
    child: ListTile(
      leading: Icon(icon, color: selected ? Colors.cyanAccent : Colors.white70),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.cyanAccent : Colors.white,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: loading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  selected ? Colors.cyanAccent : Colors.white70,
                ),
                backgroundColor: Colors.transparent,
              ),
            )
          : count != null
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.cyanAccent.withOpacity(0.2)
                        : Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      color: selected ? Colors.cyanAccent : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
      onTap: onTap,
    ),
  );
}
