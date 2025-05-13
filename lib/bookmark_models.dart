class BookmarkQuery {
  final String? search;
  final String? title;
  final String? author;
  final String? site;
  final List<String>? type;
  final String? labels;
  final bool? isLoaded;
  final bool? hasErrors;
  final bool? hasLabels;
  final bool? isMarked;
  final bool? isArchived;
  final String? rangeStart;
  final String? rangeEnd;
  final List<String>? readStatus;
  final String? updatedSince;
  final String? id;
  final String? collection;

  BookmarkQuery({
    this.search,
    this.title,
    this.author,
    this.site,
    this.type,
    this.labels,
    this.isLoaded,
    this.hasErrors,
    this.hasLabels,
    this.isMarked,
    this.isArchived,
    this.rangeStart,
    this.rangeEnd,
    this.readStatus,
    this.updatedSince,
    this.id,
    this.collection,
  });

  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {};
    if (search != null) params['search'] = search;
    if (title != null) params['title'] = title;
    if (author != null) params['author'] = author;
    if (site != null) params['site'] = site;
    if (type != null && type!.isNotEmpty) params['type'] = type;
    if (labels != null) params['labels'] = labels;
    if (isLoaded != null) params['is_loaded'] = isLoaded;
    if (hasErrors != null) params['has_errors'] = hasErrors;
    if (hasLabels != null) params['has_labels'] = hasLabels;
    if (isMarked != null) params['is_marked'] = isMarked;
    if (isArchived != null) params['is_archived'] = isArchived;
    if (rangeStart != null) params['range_start'] = rangeStart;
    if (rangeEnd != null) params['range_end'] = rangeEnd;
    if (readStatus != null && readStatus!.isNotEmpty)
      params['read_status'] = readStatus;
    if (updatedSince != null) params['updated_since'] = updatedSince;
    if (id != null) params['id'] = id;
    if (collection != null) params['collection'] = collection;
    return params;
  }
}

class BookmarkSummary {
  final String id;
  final String href;
  final String created;
  final String updated;
  final int state;
  final bool loaded;
  final String url;
  final String title;
  final String? siteName;
  final String? site;
  final String? published;
  final List<String>? authors;
  final String? lang;
  final String? textDirection;
  final String? documentType;
  final String type;
  final bool hasArticle;
  final String? description;
  final bool isDeleted;
  final bool isMarked;
  final bool isArchived;
  final int? readProgress;
  final Resources resources;
  final List<String>? labels;
  final int? wordCount;
  final int? readingTime;

  BookmarkSummary({
    required this.id,
    required this.href,
    required this.created,
    required this.updated,
    required this.state,
    required this.loaded,
    required this.url,
    required this.title,
    this.siteName,
    this.site,
    this.published,
    this.authors,
    this.lang,
    this.textDirection,
    this.documentType,
    required this.type,
    required this.hasArticle,
    this.description,
    required this.isDeleted,
    required this.isMarked,
    required this.isArchived,
    this.readProgress,
    required this.resources,
    this.labels,
    this.wordCount,
    this.readingTime,
  });

  factory BookmarkSummary.fromJson(Map<String, dynamic> json) =>
      BookmarkSummary(
        id: json['id'],
        href: json['href'],
        created: json['created'],
        updated: json['updated'],
        state: json['state'],
        loaded: json['loaded'],
        url: json['url'],
        title: json['title'],
        siteName: json['site_name'],
        site: json['site'],
        published: json['published'],
        authors: (json['authors'] as List?)?.map((e) => e.toString()).toList(),
        lang: json['lang'],
        textDirection: json['text_direction'],
        documentType: json['document_type'],
        type: json['type'],
        hasArticle: json['has_article'],
        description: json['description'],
        isDeleted: json['is_deleted'],
        isMarked: json['is_marked'],
        isArchived: json['is_archived'],
        readProgress: json['read_progress'],
        resources: Resources.fromJson(json['resources']),
        labels: (json['labels'] as List?)?.map((e) => e.toString()).toList(),
        wordCount: json['word_count'],
        readingTime: json['reading_time'],
      );
}

class BookmarkInfo extends BookmarkSummary {
  final String? readAnchor;
  final List<Map<String, dynamic>>? links;

  BookmarkInfo({
    required super.id,
    required super.href,
    required super.created,
    required super.updated,
    required super.state,
    required super.loaded,
    required super.url,
    required super.title,
    super.siteName,
    super.site,
    super.published,
    super.authors,
    super.lang,
    super.textDirection,
    super.documentType,
    required super.type,
    required super.hasArticle,
    super.description,
    required super.isDeleted,
    required super.isMarked,
    required super.isArchived,
    super.readProgress,
    super.labels,
    required super.resources,
    super.wordCount,
    super.readingTime,
    this.readAnchor,
    this.links,
  });

  factory BookmarkInfo.fromJson(Map<String, dynamic> json) => BookmarkInfo(
        id: json['id'],
        href: json['href'],
        created: json['created'],
        updated: json['updated'],
        state: json['state'],
        loaded: json['loaded'],
        url: json['url'],
        title: json['title'],
        siteName: json['site_name'],
        site: json['site'],
        published: json['published'],
        authors: (json['authors'] as List?)?.map((e) => e.toString()).toList(),
        lang: json['lang'],
        textDirection: json['text_direction'],
        documentType: json['document_type'],
        type: json['type'],
        hasArticle: json['has_article'],
        description: json['description'],
        isDeleted: json['is_deleted'],
        isMarked: json['is_marked'],
        isArchived: json['is_archived'],
        readProgress: json['read_progress'],
        labels: (json['labels'] as List?)?.map((e) => e.toString()).toList(),
        resources: Resources.fromJson(json['resources']),
        wordCount: json['word_count'],
        readingTime: json['reading_time'],
        readAnchor: json['read_anchor'],
        links: (json['links'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList(),
      );
}

class Resources {
  Log? article;
  ReadeckIcon? icon;
  ReadeckIcon? image;
  Log log;
  Log props;
  ReadeckIcon? thumbnail;

  Resources({
    this.article,
    this.icon,
    this.image,
    required this.log,
    required this.props,
    this.thumbnail,
  });

  factory Resources.fromJson(Map<String, dynamic> json) => Resources(
        article: json["article"] == null ? null : Log.fromJson(json["article"]),
        icon: json["icon"] == null ? null : ReadeckIcon.fromJson(json["icon"]),
        image: json["image"] == null ? null : ReadeckIcon.fromJson(json["image"]),
        log: Log.fromJson(json["log"]),
        props: Log.fromJson(json["props"]),
        thumbnail:
            json["thumbnail"] == null ? null : ReadeckIcon.fromJson(json["thumbnail"]),
      );

  Map<String, dynamic> toJson() => {
        "article": article?.toJson(),
        "icon": icon?.toJson(),
        "image": image?.toJson(),
        "log": log.toJson(),
        "props": props.toJson(),
        "thumbnail": thumbnail?.toJson(),
      };
}

class Log {
  String src;

  Log({
    required this.src,
  });

  factory Log.fromJson(Map<String, dynamic> json) => Log(
        src: json["src"],
      );

  Map<String, dynamic> toJson() => {
        "src": src,
      };
}

class ReadeckIcon {
  String src;
  int width;
  int height;

  ReadeckIcon({
    required this.src,
    required this.width,
    required this.height,
  });

  factory ReadeckIcon.fromJson(Map<String, dynamic> json) => ReadeckIcon(
        src: json["src"],
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "src": src,
        "width": width,
        "height": height,
      };
}

// Model for aggregated bookmark counts response
class BookmarkCount {
  final int archived;
  final Map<String, int> byType;
  final int marked;
  final int total;
  final int unread;

  BookmarkCount({
    required this.archived,
    required this.byType,
    required this.marked,
    required this.total,
    required this.unread,
  });

  factory BookmarkCount.fromJson(Map<String, dynamic> json) {
    return BookmarkCount(
      archived: json['archived'] as int,
      byType: (json['by_type'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, v as int)),
      marked: json['marked'] as int,
      total: json['total'] as int,
      unread: json['unread'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'archived': archived,
        'by_type': byType,
        'marked': marked,
        'total': total,
        'unread': unread,
      };
}
