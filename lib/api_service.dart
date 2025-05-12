import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_provider.dart';
import 'bookmark_models.dart';

class ApiService {
  final String baseUrl;
  final AuthProvider authProvider;

  ApiService({required this.baseUrl, required this.authProvider});

  Future<bool> authenticate(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth');
    final body = json.encode({
      'application': 'Readeck Flutter App',
      'username': username,
      'password': password,
    });

    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      final token = data['token'];
      await authProvider.setAuthenticated(token, baseUrl);
      return true;
    }
    return false;
  }

  // --- BOOKMARKS API ---

  /// Get a paginated list of bookmarks (typed)
  Future<List<BookmarkSummary>> getBookmarksTyped(
      {BookmarkQuery? query}) async {
    final token = authProvider.token;
    if (token == null) {
      throw Exception('No token found');
    }
    var uri = Uri.parse('$baseUrl/api/bookmarks?limit=1000');
    if (query != null) {
      final params = query.toQueryParams();
      if (params.isNotEmpty) {
        uri = uri.replace(
            queryParameters: params.map((k, v) => MapEntry(k, v.toString())));
      }
    }
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'accept': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      await authProvider.setUnauthenticated();
      throw Exception('Unauthorized');
    }
    if (response.statusCode == 200) {
      final List<dynamic> list = json.decode(response.body);
      return list.map((e) => BookmarkSummary.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load bookmarks: ${response.statusCode}');
    }
  }

  /// Create a new bookmark (typed response: returns created bookmark ID)
  Future<String?> createBookmarkTyped(
      {required String url, String? title, List<String>? labels}) async {
    final token = authProvider.token;
    if (token == null) {
      throw Exception('No token found');
    }
    final apiUrl = Uri.parse('$baseUrl/api/bookmarks');
    final body = <String, dynamic>{'url': url};
    if (title != null) body['title'] = title;
    if (labels != null) body['labels'] = labels;
    final response = await http.post(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'accept': 'application/json',
        'content-type': 'application/json',
      },
      body: json.encode(body),
    );
    if (response.statusCode == 401) {
      await authProvider.setUnauthenticated();
      throw Exception('Unauthorized');
    }
    if (response.statusCode == 202) {
      return response.headers['bookmark-id'];
    } else {
      throw Exception('Failed to create bookmark: ${response.statusCode}');
    }
  }

  /// Get details for a specific bookmark (typed)
  Future<BookmarkInfo> getBookmarkDetailsTyped(String bookmarkId) async {
    final token = authProvider.token;
    if (token == null) {
      throw Exception('No token found');
    }
    final url = Uri.parse('$baseUrl/api/bookmarks/$bookmarkId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'accept': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      await authProvider.setUnauthenticated();
      throw Exception('Unauthorized');
    }
    if (response.statusCode == 200) {
      return BookmarkInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to fetch bookmark details: ${response.statusCode}');
    }
  }

  /// Get the article content for a bookmark (typed, returns HTML fragment as String)
  Future<String> getBookmarkArticleTyped(String bookmarkId) async {
    final token = authProvider.token;
    if (token == null) {
      throw Exception('No token found');
    }
    final url = Uri.parse('$baseUrl/api/bookmarks/$bookmarkId/article');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'accept': 'text/html',
      },
    );
    if (response.statusCode == 401) {
      await authProvider.setUnauthenticated();
      throw Exception('Unauthorized');
    }
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
          'Failed to fetch bookmark article: ${response.statusCode}');
    }
  }
// --- COUNT API ---

  Future<int> getTotalBookmarkCount() async {
    final token = authProvider.token;
    if (token == null) {
      throw Exception('No token found');
    }
    final url = Uri.parse('$baseUrl/api/bookmarks?limit=1');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'accept': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      await authProvider.setUnauthenticated();
      throw Exception('Unauthorized');
    }
    if (response.statusCode == 200) {
      return int.parse(response.headers['total-count'] ?? '0');
    } else {
      throw Exception(
          'Failed to fetch bookmark count: ${response.statusCode}');
    }
  }

  Future<int> getUnreadBookmarkCount() async {
    final token = authProvider.token;
    if (token == null) {
      throw Exception('No token found');
    }
    final url = Uri.parse('$baseUrl/api/bookmarks?limit=1&read_status=unread');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'accept': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      await authProvider.setUnauthenticated();
      throw Exception('Unauthorized');
    }
    if (response.statusCode == 200) {
      return int.parse(response.headers['total-count'] ?? '0');
    } else {
      throw Exception(
          'Failed to fetch bookmark count: ${response.statusCode}');
    }
  }

  Future<int> getArchivedBookmarkCount() async {
    final token = authProvider.token;
    if (token == null) {
      throw Exception('No token found');
    }
    final url = Uri.parse('$baseUrl/api/bookmarks?limit=1&is_archived=true');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'accept': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      await authProvider.setUnauthenticated();
      throw Exception('Unauthorized');
    }
    if (response.statusCode == 200) {
      return int.parse(response.headers['total-count'] ?? '0');
    } else {
      throw Exception(
          'Failed to fetch bookmark count: ${response.statusCode}');
    }
  }

  Future<int> getFavoriteBookmarkCount() async {
    final token = authProvider.token;
    if (token == null) {
      throw Exception('No token found');
    }
    final url = Uri.parse('$baseUrl/api/bookmarks?limit=1&is_marked=true');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'accept': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      await authProvider.setUnauthenticated();
      throw Exception('Unauthorized');
    }
    if (response.statusCode == 200) {
      return int.parse(response.headers['total-count'] ?? '0');
    } else {
      throw Exception(
          'Failed to fetch bookmark count: ${response.statusCode}');
    }
  }

  Future<int> getVideoBookmarkCount() async {
    final token = authProvider.token;
    if (token == null) {
      throw Exception('No token found');
    }
    final url = Uri.parse('$baseUrl/api/bookmarks?limit=1&type=video');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'accept': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      await authProvider.setUnauthenticated();
      throw Exception('Unauthorized');
    }
    if (response.statusCode == 200) {
      return int.parse(response.headers['total-count'] ?? '0');
    } else {
      throw Exception(
          'Failed to fetch bookmark count: ${response.statusCode}');
    }
  }

  Future<int> getArticleBookmarkCount() async {
    final token = authProvider.token;
    if (token == null) {
      throw Exception('No token found');
    }
    final url = Uri.parse('$baseUrl/api/bookmarks?limit=1&type=article');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'accept': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      await authProvider.setUnauthenticated();
      throw Exception('Unauthorized');
    }
    if (response.statusCode == 200) {
      return int.parse(response.headers['total-count'] ?? '0');
    } else {
      throw Exception(
          'Failed to fetch bookmark count: ${response.statusCode}');
    }
  }
}
