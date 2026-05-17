class Property {
  final String
  id;

  final String
  title;
  final String
  description;

  final String
  city;
  final String
  type;

  final double
  price;

  final List<
    String
  >
  images;

  final int
  likes;
  final int
  comments;
  final int
  shares;
  final int
  views;

  final Owner
  owner;

  final bool
  isFavorite;

  /// 🏠 Detalles Inmobiliarios
  final bool
  isForSale;
  final int
  bedrooms;
  final int
  bathrooms;
  final int
  parking;
  final double
  size;
  final String
  location;
  final double?
  latitude;
  final double?
  longitude;
  final bool
  hasKitchen;
  final int
  floor;
  final bool
  hasElevator;
  final bool
  hasBalcony;
  final bool
  hasPatio;
  final bool
  hasTerrace;
  final bool
  isFurnished;
  final bool
  hasWifi;
  final bool
  hasAirConditioning;
  final String
  landType;
  final String
  landAccess;
  final String
  setback;
  final List<
    String
  >
  amenities;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.city,
    required this.type,
    required this.price,
    required this.images,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.views,
    required this.owner,
    required this.isFavorite,
    this.isForSale =
        true,
    this.bedrooms =
        0,
    this.bathrooms =
        0,
    this.parking =
        0,
    this.size =
        0.0,
    this.location =
        '',
    this.latitude,
    this.longitude,
    this.hasKitchen =
        false,
    this.floor =
        0,
    this.hasElevator =
        false,
    this.hasBalcony =
        false,
    this.hasPatio =
        false,
    this.hasTerrace =
        false,
    this.isFurnished =
        false,
    this.hasWifi =
        false,
    this.hasAirConditioning =
        false,
    this.landType =
        '',
    this.landAccess =
        '',
    this.setback =
        '',
    this.amenities =
        const [],
  });
}

class Owner {
  final String
  id;
  final String
  name;
  final String
  avatar;
  final bool
  verified;

  Owner({
    String?
    id,
    required this.name,
    required this.avatar,
    required this.verified,
  }) : id =
           id ??
           name;
}
