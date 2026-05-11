import 'package:app_hogar_ya/models/property.dart';
import 'package:flutter/material.dart';
// Importamos el widget PropertyCard para mantener la consistencia visual
import '../widgets/property_card.dart'; 

class OwnerProfileScreen extends StatelessWidget {
  final Owner owner;
  final List<Property> properties;

  const OwnerProfileScreen({
    super.key,
    required this.owner,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          owner.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          /// 👤 HEADER
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(owner.avatar),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        owner.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (owner.verified)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(
                            Icons.verified,
                            color: Colors.blue,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Propietario en HogarYa",
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _stat("Publicaciones", properties.length.toString()),
                      _stat("Seguidores", "1.2K"),
                      _stat("Ventas", "34"),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// 🏠 PUBLICACIONES (Igual a ProfileScreen)
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // Pasamos la propiedad real al widget PropertyCard
                  return PropertyCard(
                    property: properties[index],
                  );
                },
                childCount: properties.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16, // Ajustado a 16 para coincidir con ProfileScreen
                crossAxisSpacing: 16, // Ajustado a 16 para coincidir con ProfileScreen
                // Si tu PropertyCard es alta, podrías necesitar childAspectRatio
                childAspectRatio: 0.75, 
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}