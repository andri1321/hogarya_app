import 'dart:io';

import 'package:app_hogar_ya/models/property.dart';
import 'package:flutter/foundation.dart';

class UserData {
  static final ValueNotifier<
    int
  >
  notifier =
      ValueNotifier<
        int
      >(
        0,
      );

  static String
  _userName =
      "Richie";

  static String
  _fullName =
      "pull name";

  static String
  _description =
      "Se entiende por usuario a aquella persona que emplea un producto o servicio, bien de forma esporádica, bien de forma habitual, y todo ello a través de una interfaz adecuada para este fin.";

  static String
  userId =
      "current_user";

  static File?
  _profileImage;

  static bool
  verified =
      true;

  static final List<
    Property
  >
  userPublications =
      [];

  static final List<
    Property
  >
  allPublications =
      [];

  static final Set<
    String
  >
  likedPublications =
      {};

  static final Set<
    String
  >
  favoritePublicationIds =
      {};

  static final Map<
    String,
    List<
      Map<
        String,
        String
      >
    >
  >
  publicationComments =
      {};

  static String
  networkImage =
      "https://i.pravatar.cc/150";

  static String
  get userName =>
      _userName;

  static set userName(
    String
    value,
  ) {
    _userName =
        value;
    _syncUserPublicationOwners();
    _notify();
  }

  static String
  get fullName =>
      _fullName;

  static set fullName(
    String
    value,
  ) {
    _fullName =
        value;
    _notify();
  }

  static String
  get description =>
      _description;

  static set description(
    String
    value,
  ) {
    _description =
        value;
    _notify();
  }

  static File?
  get profileImage =>
      _profileImage;

  static set profileImage(
    File?
    value,
  ) {
    _profileImage =
        value;
    _syncUserPublicationOwners();
    _notify();
  }

  static void
  setInitialPublications(
    List<
      Property
    >
    publications,
  ) {
    final missingPublications = publications.where(
      (
        publication,
      ) => !allPublications.any(
        (
          item,
        ) =>
            item.id ==
            publication.id,
      ),
    );

    allPublications.addAll(
      missingPublications,
    );

    for (final publication
        in publications) {
      if (publication.isFavorite) {
        favoritePublicationIds.add(
          publication.id,
        );
      }
    }
  }

  static void
  addPublication(
    Property
    property,
  ) {
    final alreadyExists = allPublications.any(
      (
        item,
      ) =>
          item.id ==
          property.id,
    );

    if (alreadyExists) {
      return;
    }

    userPublications.insert(
      0,
      property,
    );
    allPublications.insert(
      0,
      property,
    );
    _notify();
  }

  static Property?
  propertyById(
    String
    id,
  ) {
    for (final property
        in allPublications) {
      if (property.id ==
          id) {
        return property;
      }
    }

    return null;
  }

  static bool
  isLiked(
    String
    propertyId,
  ) {
    return likedPublications.contains(
      propertyId,
    );
  }

  static bool
  isFavorite(
    String
    propertyId,
  ) {
    return favoritePublicationIds.contains(
      propertyId,
    );
  }

  static List<
    Property
  >
  get favoriteProperties {
    return allPublications
        .where(
          (
            property,
          ) => favoritePublicationIds.contains(
            property.id,
          ),
        )
        .toList();
  }

  static void
  toggleFavorite(
    Property
    property,
  ) {
    final favorite = favoritePublicationIds.contains(
      property.id,
    );

    if (favorite) {
      favoritePublicationIds.remove(
        property.id,
      );
    } else {
      favoritePublicationIds.add(
        property.id,
      );
    }

    final current =
        propertyById(
          property.id,
        ) ??
        property;

    _replacePublication(
      current,
      isFavorite: !favorite,
    );
  }

  static void
  toggleLike(
    Property
    property,
  ) {
    final liked = likedPublications.contains(
      property.id,
    );

    if (liked) {
      likedPublications.remove(
        property.id,
      );
    } else {
      likedPublications.add(
        property.id,
      );
    }

    final current =
        propertyById(
          property.id,
        ) ??
        property;

    _replacePublication(
      current,
      likes: liked
          ? current.likes >
                    0
                ? current.likes -
                      1
                : 0
          : current.likes +
                1,
    );
  }

  static List<
    Map<
      String,
      String
    >
  >
  commentsFor(
    String
    propertyId,
  ) {
    return publicationComments[propertyId] ??
        [];
  }

  static void
  addComment(
    Property
    property,
    String
    comment,
  ) {
    final text =
        comment.trim();

    if (text.isEmpty) {
      return;
    }

    final comments = publicationComments.putIfAbsent(
      property.id,
      () => [],
    );

    comments.add({
      "name": userName,
      "avatar": ownerAvatar,
      "comment": text,
      "time": "Ahora",
    });

    final current =
        propertyById(
          property.id,
        ) ??
        property;

    _replacePublication(
      current,
      comments:
          current.comments +
          1,
    );
  }

  static void
  incrementShares(
    Property
    property,
  ) {
    final current =
        propertyById(
          property.id,
        ) ??
        property;

    _replacePublication(
      current,
      shares:
          current.shares +
          1,
    );
  }

  static String
  get ownerAvatar =>
      _profileImage?.path ??
      networkImage;

  static void
  _syncUserPublicationOwners() {
    for (
      var index = 0;
      index <
          userPublications.length;
      index++
    ) {
      final updated = _withCurrentOwner(
        userPublications[index],
      );

      userPublications[index] = updated;

      final allIndex = allPublications.indexWhere(
        (
          item,
        ) =>
            item.id ==
            updated.id,
      );

      if (allIndex !=
          -1) {
        allPublications[allIndex] = updated;
      }
    }
  }

  static Property
  _withCurrentOwner(
    Property
    property,
  ) {
    return _copyProperty(
      property,
      owner: Owner(
        id: userId,
        name: _userName,
        avatar: ownerAvatar,
        verified: verified,
      ),
    );
  }

  static void
  _replacePublication(
    Property
    property, {
    int?
    likes,
    int?
    comments,
    int?
    shares,
    bool?
    isFavorite,
  }) {
    final updated = _copyProperty(
      property,
      likes: likes,
      comments: comments,
      shares: shares,
      isFavorite: isFavorite,
    );

    final allIndex = allPublications.indexWhere(
      (
        item,
      ) =>
          item.id ==
          updated.id,
    );

    if (allIndex !=
        -1) {
      allPublications[allIndex] = updated;
    }

    final userIndex = userPublications.indexWhere(
      (
        item,
      ) =>
          item.id ==
          updated.id,
    );

    if (userIndex !=
        -1) {
      userPublications[userIndex] = updated;
    }

    _notify();
  }

  static Property
  _copyProperty(
    Property
    property, {
    int?
    likes,
    int?
    comments,
    int?
    shares,
    bool?
    isFavorite,
    Owner?
    owner,
  }) {
    return Property(
      id: property.id,
      title: property.title,
      description: property.description,
      city: property.city,
      type: property.type,
      price: property.price,
      images: property.images,
      likes:
          likes ??
          property.likes,
      comments:
          comments ??
          property.comments,
      shares:
          shares ??
          property.shares,
      views: property.views,
      owner:
          owner ??
          property.owner,
      isFavorite:
          isFavorite ??
          property.isFavorite,
      // 🏠 Preservar detalles inmobiliarios
      isForSale: property.isForSale,
      bedrooms: property.bedrooms,
      bathrooms: property.bathrooms,
      parking: property.parking,
      size: property.size,
      location: property.location,
      hasKitchen: property.hasKitchen,
      floor: property.floor,
      hasElevator: property.hasElevator,
      hasBalcony: property.hasBalcony,
      hasPatio: property.hasPatio,
      hasTerrace: property.hasTerrace,
      isFurnished: property.isFurnished,
      hasWifi: property.hasWifi,
      hasAirConditioning: property.hasAirConditioning,
      landType: property.landType,
      landAccess: property.landAccess,
      setback: property.setback,
      amenities: property.amenities,
    );
  }

  static void
  _notify() {
    notifier.value++;
  }
}
