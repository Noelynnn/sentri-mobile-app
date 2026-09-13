enum LearningResourceType {
  video,
  article,
}

class LearningResource {
  final String title;
  final String source;
  final String url;
  final LearningResourceType type;
  final String? duration;

  const LearningResource({
    required this.title,
    required this.source,
    required this.url,
    required this.type,
    this.duration,
  });
}
