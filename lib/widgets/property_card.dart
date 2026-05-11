import 'package:app_hogar_ya/models/property.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PropertyCard extends StatelessWidget {

  final Property property;

  const PropertyCard({
    super.key,
    required this.property,
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
                image: NetworkImage(
                  property.images.first,
                ),
                fit: BoxFit.cover,
              ),
            ),

            const Positioned(
              top: 10,
              right: 10,
              child: Icon(
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

                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      property.type,

                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),

                    Text(
                      property.city,

                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),

                    const Text(
                      'Ver detalles',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
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
}