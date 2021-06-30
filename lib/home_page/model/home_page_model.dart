class HomePageModel {
  final int id;
  final String name;
  final List<String> categories;
  final bool isOpenNow;
  final int eta;
  final int etaBuffer;
  final String mediaURL;

  HomePageModel({
    this.id,
    this.name,
    this.categories,
    this.isOpenNow,
    this.eta,
    this.etaBuffer,
    this.mediaURL,
  });

  factory HomePageModel.fromJson(Map<String, dynamic> json) {
    return HomePageModel(
      id: json['id'],
      name: json['name'] ?? '',
      categories: [],
      isOpenNow: json['is_open_now'] ?? false,
      eta: json['eta'] ?? 0,
      etaBuffer: json['eta_buffer'] ?? 15,
      mediaURL: json['media'].length > 0 ? json['media'][0]['thumb'] : '',
    );
  }
}
