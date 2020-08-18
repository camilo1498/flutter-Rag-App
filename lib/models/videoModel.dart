class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;
  final String duration;
  final String date;
  final String views;

  Video({
    this.id,
    this.title,
    this.thumbnailUrl,
    this.channelTitle,
    this.duration,
    this.date,
    this.views
  });

  factory Video.fromMap(Map<String, dynamic> snippet) {
    return Video(
        id: snippet['id'],
        title: snippet['snippet']['title'],
        thumbnailUrl: snippet['snippet']['thumbnails']['high']['url'],
        channelTitle: snippet['channelTitle'],
        date: snippet['snippet']['publishedAt'],
        duration: snippet['contentDetails']['duration'],
        views: snippet['statistics']['viewCount']
    );
  }

  Video.fromData(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        thumbnailUrl = data['thumbnailUrl'],
        channelTitle = data['channelTitle'],
        date = data['date'],
        duration = data['duration'],
        views = data['views']
      ;

  Map<String, dynamic>toJson(){
    return{
      'id': id,
      'title' : title,
      'thumbnailUrl' : thumbnailUrl,
      'channelTitle': channelTitle,
      'date' : date,
      'duration': duration,
      'views': views,
    };
  }

}