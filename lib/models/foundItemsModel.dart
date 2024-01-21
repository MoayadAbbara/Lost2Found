class FoundItemsModel {
  late String id;
  late String title;
  late String category;
  late String photoUrl;
  late String description;
  late String userId; // User who found it
  late String notes;
  late double latitude;
  late double longitude;

  FoundItemsModel({
    required this.title,
    required this.category,
    //required this.city,
    required this.photoUrl,
    required this.description,
    required this.userId,
    //required this.foundDateTime,
    required this.notes,
    required this.latitude,
    required this.longitude
  });

FoundItemsModel.fromSnapshot(Map items) {
  title = items["title"] ?? "";
  category = items['category'] ?? "";
  photoUrl = items['photoUrl'] ?? "";
  description = items['description'] ?? "";
  userId = items['userId'] ?? "";
  notes = items['notes'] ?? "";
  latitude = (items['latitude'] ?? 0).toDouble();
  longitude = (items['longitude'] ?? 0).toDouble();
}
    
    Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      //'city': city,
      'photoUrl': photoUrl,
      'description': description,
      'userId': userId,
      'notes': notes,
      'latitude' : latitude,
      'longitude' : longitude,
    };
  }
}