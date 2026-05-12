class Property {
  final String id;

  final String title;
  final String description;

  final String city;
  final String type;

  final double price;

  final List<String> images;

  final int likes;
  final int comments;
  final int shares;
  final int views;

  final Owner owner;

  final bool isFavorite;

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
  });
}


class Owner {
  final String id;
  final String name;
  final String avatar;
  final bool verified;

  Owner({
    String? id,
    required this.name,
    required this.avatar,
    required this.verified,
  }) : id = id ?? name;
}
