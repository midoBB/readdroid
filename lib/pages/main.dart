import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readeck/components/drawer.dart';
import '../auth_provider.dart';
import '../api_service.dart';
import '../bookmark_models.dart';



class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final apiService = ApiService(
      baseUrl: authProvider.serverAddress!,
      authProvider: authProvider,
    );

    return Scaffold(
      drawer: BookmarksDrawer(apiService: apiService),
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
      body: FutureBuilder<List<BookmarkSummary>>(
        future: apiService.getBookmarksTyped(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookmarks found.'));
          } else {
            final bookmarks = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
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
                          child: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                              ? Image.network(
                                  thumbnailUrl,
                                  height: 140,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  style: Theme.of(context).textTheme.bodyMedium,
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
            );
          }
        },
      ),
    );
  }
}
