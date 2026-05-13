/// 🔥 PROPERTY DETAILS SCREEN COMPLETA

import 'dart:io';

import 'package:app_hogar_ya/data/user_data.dart';
import 'package:app_hogar_ya/models/property.dart';
import 'package:app_hogar_ya/widgets/property_social_actions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PropertyDetailsScreen
    extends
        StatefulWidget {
  final Property
  property;

  const PropertyDetailsScreen({
    super.key,
    required this.property,
  });

  @override
  State<
    PropertyDetailsScreen
  >
  createState() =>
      _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState
    extends
        State<
          PropertyDetailsScreen
        > {
  int
  currentPage =
      0;

  @override
  void
  initState() {
    super.initState();

    UserData.notifier.addListener(
      _refreshProperty,
    );
  }

  @override
  void
  dispose() {
    UserData.notifier.removeListener(
      _refreshProperty,
    );

    super.dispose();
  }

  void
  _refreshProperty() {
    if (!mounted) {
      return;
    }

    setState(
      () {},
    );
  }

  String
  formatPrice(
    double
    price,
  ) {
    return "RD\$${price.toInt().toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ",")}";
  }

  @override
  Widget
  build(
    BuildContext
    context,
  ) {
    final property =
        UserData.propertyById(
          widget.property.id,
        ) ??
        widget.property;

    final isLiked = UserData.isLiked(
      property.id,
    );

    final isFavorite = UserData.isFavorite(
      property.id,
    );

    return Scaffold(
      backgroundColor: Colors.white,

      body: CustomScrollView(
        slivers: [
          /// 🔥 APPBAR IMAGENES
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: Colors.black,

            leading: Padding(
              padding: const EdgeInsets.all(
                8,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(
                  0.4,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                ),
              ),
            ),

            actions: [
              Padding(
                padding: const EdgeInsets.all(
                  8,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(
                    0.4,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isFavorite
                          ? Colors.red
                          : Colors.white,
                    ),
                    onPressed: () {
                      UserData.toggleFavorite(
                        property,
                      );
                    },
                  ),
                ),
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  /// 🔥 PAGEVIEW
                  PageView.builder(
                    itemCount: property.images.length,

                    onPageChanged:
                        (
                          index,
                        ) {
                          setState(
                            () {
                              currentPage = index;
                            },
                          );
                        },

                    itemBuilder:
                        (
                          _,
                          index,
                        ) {
                          return Hero(
                            tag: property.id,
                            child: Image(
                              image: _imageProvider(
                                property.images[index],
                              ),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                  ),

                  /// 🔥 INDICADOR
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        property.images.length,
                        (
                          index,
                        ) {
                          final active =
                              currentPage ==
                              index;

                          return AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 300,
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            width: active
                                ? 24
                                : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: active
                                  ? Colors.white
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 🔥 CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔥 TITULO
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  /// 🔥 PRECIO
                  Text(
                    formatPrice(
                      property.price,
                    ),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  /// 🔥 UBICACION
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                      ),

                      const SizedBox(
                        width: 6,
                      ),

                      Text(
                        property.city,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  /// 🔥 TIPO DE PROPIEDAD Y DETALLES VISUALES
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _statusChip(
                        property.isForSale
                            ? 'En Venta'
                            : 'En Alquiler',
                        property.isForSale
                            ? Colors.blue.shade50
                            : Colors.orange.shade50,
                        property.isForSale
                            ? Colors.blue.shade700
                            : Colors.orange.shade700,
                      ),

                      const SizedBox(
                        height: 28,
                      ),

                      buildPropertyDetailsSection(
                        property,
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      /// 🔥 STATS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _stat(
                            isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            property.likes.toString(),
                            color: isLiked
                                ? Colors.red
                                : Colors.black,
                            onTap: () {
                              PropertySocialActions.toggleLike(
                                property,
                              );
                            },
                          ),

                          _stat(
                            Icons.chat_outlined,
                            property.comments.toString(),
                            onTap: () {
                              PropertySocialActions.showCommentsModal(
                                context,
                                property,
                              );
                            },
                          ),

                          _stat(
                            Icons.send,
                            property.shares.toString(),
                            onTap: () {
                              PropertySocialActions.sharePost(
                                context,
                                property,
                              );
                            },
                          ),

                          _stat(
                            Icons.visibility,
                            property.views.toString(),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 36,
                      ),
                    ],
                  ),

                  /// 🔥 DESCRIPCION
                  const Text(
                    "Descripción",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Text(
                    property.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  /// 🔥 AMENIDADES
                  if (property.amenities.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Amenidades",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: property.amenities
                              .map(
                                (
                                  amenity,
                                ) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                    border: Border.all(
                                      color: Colors.blue.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    amenity,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),

                  /// 🔥 OWNER
                  const Text(
                    "Propietario",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  Container(
                    padding: const EdgeInsets.all(
                      16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFF5F5F5,
                      ),
                      borderRadius: BorderRadius.circular(
                        18,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: _imageProvider(
                            property.owner.avatar,
                          ),
                        ),

                        const SizedBox(
                          width: 14,
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    property.owner.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 5,
                                  ),

                                  if (property.owner.verified)
                                    const Icon(
                                      Icons.verified,
                                      color: Colors.blue,
                                      size: 18,
                                    ),
                                ],
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              const Text(
                                "Propietario verificado",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            context.push(
                              '/chatConversation',
                              extra: property,
                            );
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                30,
                              ),
                            ),
                          ),

                          child: const Text(
                            "Chat",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider
  _imageProvider(
    String
    image,
  ) {
    if (image.startsWith(
      'http',
    )) {
      return NetworkImage(
        image,
      );
    }

    return FileImage(
      File(
        image,
      ),
    );
  }

  Widget
  _statusChip(
    String
    label,
    Color
    background,
    Color
    textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(
          24,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget
  buildPropertyDetailsSection(
    Property
    property,
  ) {
    final features = _propertyFeatures(
      property,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Detalles de la propiedad",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 14,
        ),

        LayoutBuilder(
          builder:
              (
                context,
                constraints,
              ) {
                final itemWidth =
                    (constraints.maxWidth -
                        12) /
                    2;

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: features.map(
                    (
                      feature,
                    ) {
                      return SizedBox(
                        width: itemWidth,
                        child: buildPropertyFeatureCard(
                          icon: feature.icon,
                          text: feature.text,
                        ),
                      );
                    },
                  ).toList(),
                );
              },
        ),
      ],
    );
  }

  List<
    _PropertyFeature
  >
  _propertyFeatures(
    Property
    property,
  ) {
    final details =
        <
          _PropertyFeature
        >[];

    bool
    hasAmenity(
      String
      needle,
    ) {
      return property.amenities.any(
        (
          item,
        ) => item.toLowerCase().contains(
          needle,
        ),
      );
    }

    String
    amountText(
      int
      value,
      String
      singular,
      String
      plural,
    ) {
      return '$value ${value == 1 ? singular : plural}';
    }

    void
    addFeature(
      IconData
      icon,
      String
      text,
    ) {
      details.add(
        _PropertyFeature(
          icon: icon,
          text: text,
        ),
      );
    }

    if (property.bedrooms >
        0) {
      addFeature(
        Icons.bed,
        amountText(
          property.bedrooms,
          'Habitación',
          'Habitaciones',
        ),
      );
    }

    if (property.bathrooms >
        0) {
      addFeature(
        Icons.bathtub_outlined,
        amountText(
          property.bathrooms,
          'Baño',
          'Baños',
        ),
      );
    }

    if (property.hasKitchen ||
        hasAmenity(
          'cocina',
        )) {
      addFeature(
        Icons.soup_kitchen_outlined,
        'Cocina',
      );
    }

    if (property.hasBalcony ||
        hasAmenity(
          'balcón',
        ) ||
        hasAmenity(
          'balcon',
        )) {
      addFeature(
        Icons.balcony,
        'Balcón',
      );
    }

    if (property.parking >
        0) {
      addFeature(
        Icons.garage_outlined,
        amountText(
          property.parking,
          'Parqueo',
          'Parqueos',
        ),
      );
    }

    if (property.size >
        0) {
      addFeature(
        Icons.square_foot,
        '${property.size.toStringAsFixed(0)} m²',
      );
    }

    if (property.hasPatio ||
        hasAmenity(
          'patio',
        )) {
      addFeature(
        Icons.nature_people,
        'Patio',
      );
    }

    if (property.hasTerrace ||
        hasAmenity(
          'terraza',
        )) {
      addFeature(
        Icons.deck,
        'Terraza',
      );
    }

    if (property.isFurnished ||
        hasAmenity(
          'amuebl',
        )) {
      addFeature(
        Icons.chair,
        'Amueblado',
      );
    }

    if (property.hasWifi ||
        hasAmenity(
          'wifi',
        )) {
      addFeature(
        Icons.wifi,
        'WiFi',
      );
    }

    if (property.hasAirConditioning ||
        hasAmenity(
          'aire',
        )) {
      addFeature(
        Icons.ac_unit,
        'Aire Acond.',
      );
    }

    if (property.floor >
        0) {
      addFeature(
        Icons.stairs,
        'Piso ${property.floor}',
      );
    }

    if (property.hasElevator ||
        hasAmenity(
          'ascensor',
        )) {
      addFeature(
        Icons.elevator,
        'Ascensor',
      );
    }

    if (property.setback.isNotEmpty) {
      addFeature(
        Icons.border_style,
        property.setback,
      );
    }

    if (property.landAccess.isNotEmpty) {
      addFeature(
        Icons.alt_route,
        property.landAccess,
      );
    }

    return details;
  }

  Widget
  _stat(
    IconData
    icon,
    String
    value, {
    Color
    color = Colors
        .black,
    VoidCallback?
    onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget
  buildPropertyFeatureCard({
    required IconData
    icon,
    required String
    text,
  }) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color: const Color(
            0xFFE0E0E0,
          ),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.black,
            size: 26,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PropertyFeature {
  final IconData
  icon;

  final String
  text;

  const _PropertyFeature({
    required this.icon,
    required this.text,
  });
}
