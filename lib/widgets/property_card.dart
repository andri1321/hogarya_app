import 'dart:io';

import 'package:app_hogar_ya/data/user_data.dart';
import 'package:app_hogar_ya/models/property.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PropertyCard extends StatelessWidget {

  final Property property;
  final bool allowFavoriteToggle;

  const PropertyCard({
    super.key,
    required this.property,
    this.allowFavoriteToggle = false,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: () {

        context.push(
          '/property-details',
          extra: property,
        );
      },

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),

        child: Stack(
          children: [

            Positioned.fill(
              child: Image(
                image: _propertyImage(
                  property.images.first,
                ),
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              top: 10,
              right: 10,
              child: allowFavoriteToggle
                  ? ValueListenableBuilder<int>(
                      valueListenable:
                          UserData.notifier,
                      builder: (
                        context,
                        value,
                        child,
                      ) {
                        final isFavorite =
                            UserData.isFavorite(
                          property.id,
                        );

                        return GestureDetector(
                          onTap: () {
                            UserData.toggleFavorite(
                              property,
                            );
                          },
                          child: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.white,
                          ),
                        );
                      },
                    )
                  : const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
              ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,

              child: Container(
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,

                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      'RD\$${property.price.toInt()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),

                    Text(
                      property.type,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                      ),
                    ),

                    Text(
                      property.city,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                      ),
                    ),

                    const Text(
                      'Ver detalles',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        decoration:
                            TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _propertyImage(String image) {
    if (image.startsWith('http')) {
      return NetworkImage(image);
    }

    return FileImage(
      File(image),
    );
  }
}
