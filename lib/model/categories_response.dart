// To parse this JSON data, do
//
//     final categoriesResponse = categoriesResponseFromMap(jsonString);

import 'dart:convert';

class CategoriesResponse {
  CategoriesResponse({
    this.status,
    this.categories,
  });

  bool? status;
  List<Category>? categories;

  factory CategoriesResponse.fromJson(String str) =>
      CategoriesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoriesResponse.fromMap(Map<String, dynamic> json) =>
      CategoriesResponse(
        status: json["status"] == null ? null : json["status"],
        categories: json["data"] == null
            ? null
            : List<Category>.from(json["data"].map((x) => Category.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "data": categories == null
            ? null
            : List<dynamic>.from(categories!.map((x) => x.toMap())),
      };
}

class Category {
  Category({
    this.id,
    this.name,
    this.slug,
    this.avatar,
    this.type,
    this.content,
    this.pId,
    this.status,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.url,
    this.myRestCatUrl,
    this.products,
  });

  int? id;
  String? name;
  dynamic slug;
  String? avatar;
  String? type;
  dynamic content;
  int? pId;
  int? status;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? url;
  String? myRestCatUrl;
  List<Product>? products;

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        type: json["type"] == null ? null : json["type"],
        content: json["content"],
        pId: json["p_id"] == null ? null : json["p_id"],
        status: json["status"] == null ? null : json["status"],
        userId: json["user_id"] == null ? null : json["user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        url: json["url"] == null ? null : json["url"],
        myRestCatUrl:
            json["my_rest_cat_url"] == null ? null : json["my_rest_cat_url"],
        products: json["products"] == null
            ? null
            : List<Product>.from(
                json["products"].map((x) => Product.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "slug": slug,
        "avatar": avatar == null ? null : avatar,
        "type": type == null ? null : type,
        "content": content,
        "p_id": pId == null ? null : pId,
        "status": status == null ? null : status,
        "user_id": userId == null ? null : userId,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "url": url == null ? null : url,
        "my_rest_cat_url": myRestCatUrl == null ? null : myRestCatUrl,
        "products": products == null
            ? null
            : List<dynamic>.from(products!.map((x) => x.toMap())),
      };
}

class Product {
  Product({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.lang,
    this.authId,
    this.mainCatId,
    this.departmentId,
    this.unitId,
    this.status,
    this.type,
    this.count,
    this.createdAt,
    this.updatedAt,
    this.total,
    this.discountedPrice,
    this.url,
    this.picture,
    this.pivot,
    this.price,
    this.preview,
    this.addons,
    this.options,
    this.extras,
    this.variants,
    this.excerpt,
    this.discountMeta,
  });

  int? id;
  String? title;
  String? slug;
  String? description;
  String? lang;
  int? authId;
  dynamic mainCatId;
  int? departmentId;
  int? unitId;
  int? status;
  int? type;
  int? count;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? total;
  String? discountedPrice;
  String? url;
  String? picture;
  ProductPivot? pivot;
  Price? price;
  Excerpt? preview;
  List<Addon>? addons;
  List<Extra>? options;
  List<Extra>? extras;
  List<Variant>? variants;
  Excerpt? excerpt;
  dynamic discountMeta;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        slug: json["slug"] == null ? null : json["slug"],
        description: json["description"] == null ? null : json["description"],
        lang: json["lang"] == null ? null : json["lang"],
        authId: json["auth_id"] == null ? null : json["auth_id"],
        mainCatId: json["main_cat_id"],
        departmentId:
            json["department_id"] == null ? null : json["department_id"],
        unitId: json["unit_id"] == null ? null : json["unit_id"],
        status: json["status"] == null ? null : json["status"],
        type: json["type"] == null ? null : json["type"],
        count: json["count"] == null ? null : json["count"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        total: json["total"] == null ? null : json["total"].toString(),
        discountedPrice: json["discounted_price"] == null
            ? null
            : json["discounted_price"].toString(),
        url: json["url"] == null ? null : json["url"],
        picture: json["picture"] == null ? null : json["picture"],
        pivot:
            json["pivot"] == null ? null : ProductPivot.fromMap(json["pivot"]),
        price: json["price"] == null ? null : Price.fromMap(json["price"]),
        preview:
            json["preview"] == null ? null : Excerpt.fromMap(json["preview"]),
        addons: json["addons"] == null
            ? null
            : List<Addon>.from(json["addons"].map((x) => Addon.fromMap(x))),
        options: json["options"] == null
            ? null
            : List<Extra>.from(json["options"].map((x) => Extra.fromMap(x))),
        extras: json["extras"] == null
            ? null
            : List<Extra>.from(json["extras"].map((x) => Extra.fromMap(x))),
        variants: json["variants"] == null
            ? null
            : List<Variant>.from(
                json["variants"].map((x) => Variant.fromMap(x))),
        excerpt:
            json["excerpt"] == null ? null : Excerpt.fromMap(json["excerpt"]),
        discountMeta: json["discount_meta"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "slug": slug == null ? null : slug,
        "description": description == null ? null : description,
        "lang": lang == null ? null : lang,
        "auth_id": authId == null ? null : authId,
        "main_cat_id": mainCatId,
        "department_id": departmentId == null ? null : departmentId,
        "unit_id": unitId == null ? null : unitId,
        "status": status == null ? null : status,
        "type": type == null ? null : type,
        "count": count == null ? null : count,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "total": total == null ? null : total,
        "discounted_price": discountedPrice == null ? null : discountedPrice,
        "url": url == null ? null : url,
        "picture": picture == null ? null : picture,
        "pivot": pivot == null ? null : pivot!.toMap(),
        "price": price == null ? null : price!.toMap(),
        "preview": preview == null ? null : preview!.toMap(),
        "addons": addons == null
            ? null
            : List<dynamic>.from(addons!.map((x) => x.toMap())),
        "options": options == null
            ? null
            : List<dynamic>.from(options!.map((x) => x.toMap())),
        "extras": extras == null
            ? null
            : List<dynamic>.from(extras!.map((x) => x.toMap())),
        "variants": variants == null
            ? null
            : List<dynamic>.from(variants!.map((x) => x.toMap())),
        "excerpt": excerpt == null ? null : excerpt!.toMap(),
        "discount_meta": discountMeta,
      };
}

class Addon {
  Addon({
    this.id,
    this.title,
    this.description,
    this.total,
    this.discountedPrice,
    this.url,
    this.picture,
    this.pivot,
    this.price,
    this.excerpt,
    this.discountMeta,
    this.preview,
  });

  int? id;
  String? title;
  String? description;
  String? total;
  String? discountedPrice;
  String? url;
  String? picture;
  AddonPivot? pivot;
  Price? price;
  dynamic excerpt;
  dynamic discountMeta;
  dynamic preview;

  factory Addon.fromJson(String str) => Addon.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Addon.fromMap(Map<String, dynamic> json) => Addon(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        total: json["total"] == null ? null : json["total"].toString(),
        discountedPrice: json["discounted_price"] == null
            ? null
            : json["discounted_price"].toString(),
        url: json["url"] == null ? null : json["url"],
        picture: json["picture"] == null ? null : json["picture"],
        pivot: json["pivot"] == null ? null : AddonPivot.fromMap(json["pivot"]),
        price: json["price"] == null ? null : Price.fromMap(json["price"]),
        excerpt: json["excerpt"],
        discountMeta: json["discount_meta"],
        preview: json["preview"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "total": total == null ? null : total,
        "discounted_price": discountedPrice == null ? null : discountedPrice,
        "url": url == null ? null : url,
        "picture": picture == null ? null : picture,
        "pivot": pivot == null ? null : pivot!.toMap(),
        "price": price == null ? null : price!.toMap(),
        "excerpt": excerpt,
        "discount_meta": discountMeta,
        "preview": preview,
      };
}

class AddonPivot {
  AddonPivot({
    this.termId,
    this.addonId,
  });

  int? termId;
  int? addonId;

  factory AddonPivot.fromJson(String str) =>
      AddonPivot.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddonPivot.fromMap(Map<String, dynamic> json) => AddonPivot(
        termId: json["term_id"] == null ? null : json["term_id"],
        addonId: json["addon_id"] == null ? null : json["addon_id"],
      );

  Map<String, dynamic> toMap() => {
        "term_id": termId == null ? null : termId,
        "addon_id": addonId == null ? null : addonId,
      };
}

class Price {
  Price({
    this.id,
    this.termId,
    this.price,
    this.quantity,
    this.minimumThreshold,
    this.enableThreshold,
  });

  int? id;
  int? termId;
  String? price;
  int? quantity;
  String? minimumThreshold;
  String? enableThreshold;

  factory Price.fromJson(String str) => Price.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Price.fromMap(Map<String, dynamic> json) => Price(
        id: json["id"] == null ? null : json["id"],
        termId: json["term_id"] == null ? null : json["term_id"],
        price: json["price"] == null ? null : json["price"].toString(),
    quantity: json["quantity"] == null ? null : json["quantity"],
    minimumThreshold: json["product_minimum_threshold"] == null ? null : json["product_minimum_threshold"],
    enableThreshold: json["enable_threshold_alert"] == null ? null : json["enable_threshold_alert"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "term_id": termId == null ? null : termId,
        "price": price == null ? null : price,
    "quantity": quantity == null ? null : quantity,
    "product_minimum_threshold": minimumThreshold == null ? null : minimumThreshold,
    "enable_threshold_alert": enableThreshold == null ? null : enableThreshold,
      };
}

class Excerpt {
  Excerpt({
    this.id,
    this.termId,
    this.type,
    this.content,
    this.image,
  });

  int? id;
  int? termId;
  dynamic type;
  String? content;
  String? image;

  factory Excerpt.fromJson(String str) => Excerpt.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Excerpt.fromMap(Map<String, dynamic> json) => Excerpt(
        id: json["id"] == null ? null : json["id"],
        termId: json["term_id"] == null ? null : json["term_id"],
        type: json["type"] == null ? null : json["type"],
        content: json["content"] == null ? null : json["content"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "term_id": termId == null ? null : termId,
        "type": type == null ? null : type,
        "content": content == null ? null : content,
        "image": image == null ? null : image,
      };
}

class Extra {
  Extra({
    this.id,
    this.itemId,
    this.price,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.extraForAllVariants,
    this.options,
    this.pivot,
  });

  int? id;
  dynamic itemId;
  String? price;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic extraForAllVariants;
  String? options;
  ExtraPivot? pivot;

  factory Extra.fromJson(String str) => Extra.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Extra.fromMap(Map<String, dynamic> json) => Extra(
        id: json["id"] == null ? null : json["id"],
        itemId: json["item_id"] == null ? null : json["item_id"],
        price: json["price"] == null ? null : json["price"].toString(),
        name: json["name"] == null ? null : json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        extraForAllVariants: json["extra_for_all_variants"] == null
            ? null
            : json["extra_for_all_variants"],
        options: json["options"] == null ? null : json["options"],
        pivot: json["pivot"] == null ? null : ExtraPivot.fromMap(json["pivot"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "item_id": itemId == null ? null : itemId,
        "price": price == null ? null : price,
        "name": name == null ? null : name,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "extra_for_all_variants":
            extraForAllVariants == null ? null : extraForAllVariants,
        "options": options == null ? null : options,
        "pivot": pivot == null ? null : pivot!.toMap(),
      };
}

class ExtraPivot {
  ExtraPivot({
    this.variantId,
    this.extraId,
  });

  dynamic variantId;
  dynamic extraId;

  factory ExtraPivot.fromJson(String str) =>
      ExtraPivot.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ExtraPivot.fromMap(Map<String, dynamic> json) => ExtraPivot(
        variantId: json["variant_id"] == null ? null : json["variant_id"],
        extraId: json["extra_id"] == null ? null : json["extra_id"],
      );

  Map<String, dynamic> toMap() => {
        "variant_id": variantId == null ? null : variantId,
        "extra_id": extraId == null ? null : extraId,
      };
}

class ProductPivot {
  ProductPivot({
    this.categoryId,
    this.termId,
  });

  int? categoryId;
  int? termId;

  factory ProductPivot.fromJson(String str) =>
      ProductPivot.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductPivot.fromMap(Map<String, dynamic> json) => ProductPivot(
        categoryId: json["category_id"] == null ? null : json["category_id"],
        termId: json["term_id"] == null ? null : json["term_id"],
      );

  Map<String, dynamic> toMap() => {
        "category_id": categoryId == null ? null : categoryId,
        "term_id": termId == null ? null : termId,
      };
}

class Variant {
  Variant({
    this.id,
    this.price,
    this.options,
    this.image,
    this.qty,
    this.enableQty,
    this.order,
    this.itemId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.mainvariants,
    this.extras,
  });

  int? id;
  String? price;
  String? options;
  String? image;
  dynamic qty;
  dynamic enableQty;
  dynamic order;
  dynamic itemId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? mainvariants;
  List<Extra>? extras;

  factory Variant.fromJson(String str) => Variant.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Variant.fromMap(Map<String, dynamic> json) => Variant(
        id: json["id"] == null ? null : json["id"],
        price: json["price"] == null ? null : json["price"].toString(),
        options: json["options"] == null ? null : json["options"],
        image: json["image"] == null ? null : json["image"],
        qty: json["qty"] == null ? null : json["qty"],
        enableQty: json["enable_qty"] == null ? null : json["enable_qty"],
        order: json["order"] == null ? null : json["order"],
        itemId: json["item_id"] == null ? null : json["item_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        mainvariants:
            json["mainvariants"] == null ? null : json["mainvariants"],
        extras: json["extras"] == null
            ? null
            : List<Extra>.from(json["extras"].map((x) => Extra.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "price": price == null ? null : price,
        "options": options == null ? null : options,
        "image": image == null ? null : image,
        "qty": qty == null ? null : qty,
        "enable_qty": enableQty == null ? null : enableQty,
        "order": order == null ? null : order,
        "item_id": itemId == null ? null : itemId,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "mainvariants": mainvariants == null ? null : mainvariants,
        "extras": extras == null
            ? null
            : List<dynamic>.from(extras!.map((x) => x.toMap())),
      };
}
