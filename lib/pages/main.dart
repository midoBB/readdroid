import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:readeck/components/drawer.dart';
import 'package:readeck/auth_provider.dart';
import 'package:readeck/api_service.dart';
import 'package:readeck/bookmark_models.dart';



class Main extends HookWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final apiService = ApiService(
      baseUrl: authProvider.serverAddress!,
      authProvider: authProvider,
    );

    final currentQuery = useState(BookmarkQuery(readStatus: ["unread"]));
    // Fetch bookmarks based on current query
    final bookmarksQuery = useQuery<List<BookmarkSummary>, Object>(
      ["bookmarks", currentQuery.value.readStatus?.join(",") ?? ""],
      () => apiService.getBookmarksTyped(query: currentQuery.value),
    );

    return Scaffold(
      drawer: BookmarksDrawer(
        apiService: apiService,
        onQueryChanged: (query) => currentQuery.value = query,
        selectedQuery: currentQuery.value,
      ),
      appBar: AppBar(
        title: Text('Read Later'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authProvider.setUnauthenticated();
            },
          ),
        ],
      ),
      body: bookmarksQuery.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookmarksQuery.error != null
              ? Center(child: Text('Error: ${bookmarksQuery.error}'))
              : bookmarksQuery.data == null || bookmarksQuery.data!.isEmpty
                  ? const Center(child: Text('No bookmarks found.'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 8),
                      itemCount: bookmarksQuery.data!.length,
                      itemBuilder: (context, index) {
                        final bookmark = bookmarksQuery.data![index];
                        final thumbnailUrl = bookmark.resources.thumbnail?.src;
                        final site = bookmark.siteName ?? bookmark.site ?? '';
                        final meta = [
                          if (site.isNotEmpty) site,
                          if (bookmark.readingTime != null)
                            '${bookmark.readingTime} min',
                        ].join(' • ');
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              // Optionally navigate to details or article view
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                  child: thumbnailUrl != null &&
                                          thumbnailUrl.isNotEmpty
                                      ? Image.network(
                                          thumbnailUrl,
                                          height: 140,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error,
                                                  stackTrace) {
                                            return Image.asset(
                                              'lib/resources/placeholder.png',
                                              height: 140,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          'lib/resources/placeholder.png',
                                          height: 140,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bookmark.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        meta,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.grey[500]),
                                      ),
                                      if (bookmark.description != null &&
                                          bookmark.description!.isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          bookmark.description!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
