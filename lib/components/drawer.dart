import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:readeck/api_service.dart';

class BookmarksDrawer extends HookWidget {
  final ApiService apiService;
  const BookmarksDrawer({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    final totalCount =
        useQuery(["totalCount"], apiService.getTotalBookmarkCount);
    final unreadCount =
        useQuery(["unreadCount"], apiService.getUnreadBookmarkCount);
    final archiveCount =
        useQuery(["archiveCount"], apiService.getArchivedBookmarkCount);
    final favoritesCount =
        useQuery(["favoritesCount"], apiService.getFavoriteBookmarkCount);
    final articlesCount =
        useQuery(["articlesCount"], apiService.getArticleBookmarkCount);
    final videosCount =
        useQuery(["videosCount"], apiService.getVideoBookmarkCount);
    return Drawer(
      child: Container(
        color: const Color(0xFF2C353A), // dark background
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
              count: totalCount.data ?? 0,
              loading: totalCount.isLoading,
              selected: false,
            ),
            _drawerItem(
              context,
              icon: Icons.mark_email_unread,
              label: 'Unread',
              count: unreadCount.data ?? 0,
              loading: unreadCount.isLoading,
              selected: true,
            ),
            _drawerItem(
              context,
              icon: Icons.archive,
              label: 'Archive',
              count: archiveCount.data ?? 0,
              loading: archiveCount.isLoading,
              selected: false,
            ),
            _drawerItem(
              context,
              icon: Icons.favorite_border,
              label: 'Favorites',
              count: favoritesCount.data ?? 0,
              loading: favoritesCount.isLoading,
              selected: false,
            ),
            _drawerItem(
              context,
              icon: Icons.article,
              label: 'Articles',
              count: articlesCount.data ?? 0,
              loading: articlesCount.isLoading,
              selected: false,
            ),
            _drawerItem(
              context,
              icon: Icons.ondemand_video,
              label: 'Videos',
              count: videosCount.data ?? 0,
              loading: videosCount.isLoading,
              selected: false,
            ),
          ],
        ),
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
      onTap: () {
        // Handle navigation here
        Navigator.pop(context);
      },
    ),
  );
}
