import 'dart:convert';

class Restaurant {
  Restaurant({
    this.id,
    this.roleId,
    this.badgeId,
    this.planId,
    this.vendorId,
    this.categoryId,
    this.slug,
    this.avatar,
    this.landingImage,
    this.name,
    this.email,
    this.balance,
    this.provider,
    this.providerUserId,
    this.phone,
    this.emailToken,
    this.pidetutransporteToken,
    this.bulleyeToken,
    this.status,
    this.latitude,
    this.longitude,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.url,
    this.myCategory,
    this.distance,
    this.categories,
    this.location,
  });

  int? id;
  int? roleId;
  int? badgeId;
  int? planId;
  dynamic vendorId;
  int? categoryId;
  String? slug;
  String? avatar;
  String? landingImage;
  String? name;
  String? email;
  String? balance;
  dynamic provider;
  dynamic providerUserId;
  dynamic phone;
  dynamic emailToken;
  String? pidetutransporteToken;
  String? bulleyeToken;
  String? status;
  dynamic latitude;
  dynamic longitude;
  DateTime? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? image;
  String? url;
  List<String>? myCategory;
  double? distance;
  List<Category>? categories;
  Location? location;

  factory Restaurant.fromJson(String str) => Restaurant.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Restaurant.fromMap(Map<String, dynamic> json) => Restaurant(
    id: json["id"] == null ? null : json["id"],
    roleId: json["role_id"] == null ? null : json["role_id"],
    badgeId: json["badge_id"] == null ? null : json["badge_id"],
    planId: json["plan_id"] == null ? null : json["plan_id"],
    vendorId: json["vendor_id"],
    categoryId: json["category_id"] == null ? null : json["category_id"],
    slug: json["slug"] == null ? null : json["slug"],
    avatar: json["avatar"] == null ? null : json["avatar"],
    landingImage: json["landing_image"] == null ? null : json["landing_image"],
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    balance: json["balance"] == null ? null : json["balance"].toString(),
    provider: json["provider"],
    providerUserId: json["provider_user_id"],
    phone: json["phone"],
    emailToken: json["email_token"],
    pidetutransporteToken: json["pidetutransporte_token"] == null ? null : json["pidetutransporte_token"],
    bulleyeToken: json["bulleyeToken"] == null ? null : json["bulleyeToken"],
    status: json["status"] == null ? null : json["status"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    image: json["image"] == null ? null : json["image"],
    url: json["url"] == null ? null : json["url"],
    myCategory: json["my_category"] == null ? null : List<String>.from(json["my_category"].map((x) => x)),
    distance: json["distance"] == null ? null :double.parse( json["distance"].toString()),
    categories: json["categories"] == null ? null : List<Category>.from(json["categories"].map((x) => Category.fromMap(x))),
    location: json["location"] == null ? null : Location.fromMap(json["location"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "role_id": roleId == null ? null : roleId,
    "badge_id": badgeId == null ? null : badgeId,
    "plan_id": planId == null ? null : planId,
    "vendor_id": vendorId,
    "category_id": categoryId == null ? null : categoryId,
    "slug": slug == null ? null : slug,
    "avatar": avatar == null ? null : avatar,
    "landing_image": landingImage == null ? null : landingImage,
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "balance": balance == null ? null : balance,
    "provider": provider,
    "provider_user_id": providerUserId,
    "phone": phone,
    "email_token": emailToken,
    "pidetutransporte_token": pidetutransporteToken == null ? null : pidetutransporteToken,
    "bulleyeToken": bulleyeToken == null ? null : bulleyeToken,
    "status": status == null ? null : status,
    "latitude": latitude,
    "longitude": longitude,
    "email_verified_at": emailVerifiedAt == null ? null : emailVerifiedAt!.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "image": image == null ? null : image,
    "url": url == null ? null : url,
    "my_category": myCategory == null ? null : List<dynamic>.from(myCategory!.map((x) => x)),
    "distance": distance == null ? null : distance,
    "categories": categories == null ? null : List<dynamic>.from(categories!.map((x) => x.toMap())),
    "location": location == null ? null : location!.toMap(),
  };
}

class Category {
  Category({
    this.id,
    this.name,
    this.slug,
    this.status,
    this.icon,
    this.createdAt,
    this.updatedAt,
    this.iconAddress,
    this.pivot,
  });

  int? id;
  String? name;
  String? slug;
  String? status;
  String? icon;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? iconAddress;
  Pivot? pivot;

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    slug: json["slug"] == null ? null : json["slug"],
    status: json["status"] == null ? null : json["status"],
    icon: json["icon"] == null ? null : json["icon"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    iconAddress: json["icon_address"] == null ? null : json["icon_address"],
    pivot: json["pivot"] == null ? null : Pivot.fromMap(json["pivot"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "slug": slug == null ? null : slug,
    "status": status == null ? null : status,
    "icon": icon == null ? null : icon,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "icon_address": iconAddress == null ? null : iconAddress,
    "pivot": pivot == null ? null : pivot!.toMap(),
  };
}

class Pivot {
  Pivot({
    this.restId,
    this.catId,
  });

  dynamic restId;
  dynamic catId;

  factory Pivot.fromJson(String str) => Pivot.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pivot.fromMap(Map<String, dynamic> json) => Pivot(
    restId: json["rest_id"] == null ? null : json["rest_id"],
    catId: json["cat_id"] == null ? null : json["cat_id"],
  );

  Map<String, dynamic> toMap() => {
    "rest_id": restId == null ? null : restId,
    "cat_id": catId == null ? null : catId,
  };
}

class Location {
  Location({
    this.userId,
    this.termId,
    this.latitude,
    this.longitude,
  });

  int? userId;
  int? termId;
  double? latitude;
  double? longitude;

  factory Location.fromJson(String str) => Location.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Location.fromMap(Map<String, dynamic> json) => Location(
    userId: json["user_id"] == null ? null : json["user_id"],
    termId: json["term_id"] == null ? null : json["term_id"],
    latitude: json["latitude"] == null ? null :double.parse(json["latitude"].toString()),
    longitude: json["longitude"] == null ? null :double.parse(json["longitude"].toString()),
  );

  Map<String, dynamic> toMap() => {
    "user_id": userId == null ? null : userId,
    "term_id": termId == null ? null : termId,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
  };
}
