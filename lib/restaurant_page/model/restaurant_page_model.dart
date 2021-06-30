class RestaurantPageModel {
  final int id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final bool isOpenNow;
  final int eta;
  final int etaBuffer;
  final String mediaURL;

  RestaurantPageModel({
    this.id,
    this.name,
    this.description,
    this.address,
    this.phone,
    this.email,
    this.isOpenNow,
    this.eta,
    this.etaBuffer,
    this.mediaURL,
  });

  factory RestaurantPageModel.fromJson(Map<String, dynamic> json) {
    return RestaurantPageModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      isOpenNow: json['is_open_now'] ?? false,
      eta: json['eta'] ?? 0,
      etaBuffer: json['eta_buffer'] ?? 15,
      mediaURL: json['media'].length > 0 ? json['media'][0]['thumb'] : '',
    );
  }
}
