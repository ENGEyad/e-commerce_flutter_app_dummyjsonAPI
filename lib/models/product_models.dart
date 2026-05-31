// lib/models/product_models.dart

class ProductListResponse {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  ProductListResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      products: (json['products'] as List<dynamic>? ?? [])
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }
}

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final num weight;
  final Dimensions dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<Review> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final ProductMeta meta;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      tags: List<String>.from(json['tags'] ?? const []),
      brand: json['brand'] ?? '',
      sku: json['sku'] ?? '',
      weight: json['weight'] ?? 0,
      dimensions: Dimensions.fromJson(json['dimensions'] ?? {}),
      warrantyInformation: json['warrantyInformation'] ?? '',
      shippingInformation: json['shippingInformation'] ?? '',
      availabilityStatus: json['availabilityStatus'] ?? '',
      reviews: (json['reviews'] as List<dynamic>? ?? [])
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
      returnPolicy: json['returnPolicy'] ?? '',
      minimumOrderQuantity: json['minimumOrderQuantity'] ?? 0,
      meta: ProductMeta.fromJson(json['meta'] ?? {}),
      thumbnail: json['thumbnail'] ?? '',
      images: List<String>.from(json['images'] ?? const []),
    );
  }

  double get discountedPrice {
    final value = price * (1 - discountPercentage / 100);
    return double.parse(value.toStringAsFixed(2));
  }
}

class Dimensions {
  final double width;
  final double height;
  final double depth;

  Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: (json['width'] ?? 0).toDouble(),
      height: (json['height'] ?? 0).toDouble(),
      depth: (json['depth'] ?? 0).toDouble(),
    );
  }
}

class Review {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      date: json['date'] ?? '',
      reviewerName: json['reviewerName'] ?? '',
      reviewerEmail: json['reviewerEmail'] ?? '',
    );
  }
}

class ProductMeta {
  final String createdAt;
  final String updatedAt;
  final String barcode;
  final String qrCode;

  ProductMeta({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  factory ProductMeta.fromJson(Map<String, dynamic> json) {
    return ProductMeta(
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      barcode: json['barcode'] ?? '',
      qrCode: json['qrCode'] ?? '',
    );
  }
}