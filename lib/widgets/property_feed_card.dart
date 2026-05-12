import 'dart:io';

import 'package:app_hogar_ya/data/user_data.dart';
import 'package:app_hogar_ya/models/property.dart';
import 'package:app_hogar_ya/screen/owner_profile_screen.dart';
import 'package:app_hogar_ya/widgets/property_social_actions.dart';
// 1. Nueva importación añadida
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PropertyFeedCard extends StatefulWidget {
  final Property property;

  const PropertyFeedCard({
    super.key,
    required this.property,
  });

  @override
  State<PropertyFeedCard> createState() => _PropertyFeedCardState();
}

class _PropertyFeedCardState extends State<PropertyFeedCard> {
  late bool isLiked;
  late bool isFavorite;
  late int likesCount;

  final List<Map<String, dynamic>> commentsList = [
    {"name": "Carlos", "comment": "Muy bonita propiedad 🔥"},
    {"name": "Maria", "comment": "¿Está disponible todavía?"},
  ];

  @override
  void initState() {
    super.initState();
    likesCount = widget.property.likes;
    isLiked = UserData.isLiked(widget.property.id);
    isFavorite = UserData.isFavorite(widget.property.id);

    UserData.notifier.addListener(
      _refreshProperty,
    );
  }

  @override
  void dispose() {
    UserData.notifier.removeListener(
      _refreshProperty,
    );

    super.dispose();
  }

  void _refreshProperty() {
    if (!mounted) {
      return;
    }

    final property =
        UserData.propertyById(widget.property.id) ??
            widget.property;

    setState(() {
      likesCount = property.likes;
      isLiked = UserData.isLiked(property.id);
      isFavorite = UserData.isFavorite(property.id);
    });
  }

  @override
  void didUpdateWidget(
    PropertyFeedCard oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.property.id !=
            widget.property.id ||
        oldWidget.property.likes !=
            widget.property.likes) {
      likesCount = widget.property.likes;
    }

    if (oldWidget.property.id !=
            widget.property.id ||
        oldWidget.property.isFavorite !=
            widget.property.isFavorite) {
      isFavorite = widget.property.isFavorite;
    }
  }

  // 2. Nueva función para abrir el perfil del dueño añadida
  void _openOwnerProfile() {
    final ownerProperties = [
      widget.property,
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OwnerProfileScreen(
          owner: widget.property.owner,
          properties: ownerProperties,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final property =
        UserData.propertyById(widget.property.id) ??
            widget.property;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          // 3. Se aplicó GestureDetector al Avatar y Nombre para abrir el perfil
          child: Row(
            children: [
              GestureDetector(
                onTap: _openOwnerProfile,
                child: CircleAvatar(radius: 18, backgroundImage: _imageProvider(property.owner.avatar)),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _openOwnerProfile,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(property.owner.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(property.city, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.push('/property-details', extra: property),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: _imageProvider(property.images.first),
                height: 320,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  PropertySocialActions.toggleLike(property);
                },
                child: Row(children: [Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? Colors.red : Colors.black), const SizedBox(width: 4), Text("$likesCount")]),
              ),
              const SizedBox(width: 18),
              GestureDetector(
                onTap: () {
                  PropertySocialActions.showCommentsModal(
                    context,
                    property,
                  );
                },
                child: Row(children: [const Icon(Icons.chat_bubble_outline), const SizedBox(width: 4), Text("${property.comments}")]),
              ),
              const SizedBox(width: 18),
              GestureDetector(
                onTap: () {
                  PropertySocialActions.sharePost(
                    context,
                    property,
                  );
                },
                child: const Icon(Icons.send_outlined),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  UserData.toggleFavorite(property);
                },
                child: Icon(isFavorite ? Icons.bookmark : Icons.bookmark_border, color: isFavorite ? const Color(0xFFFF4D5A) : Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ImageProvider _imageProvider(String image) {
    if (image.startsWith('http')) {
      return NetworkImage(image);
    }

    return FileImage(
      File(image),
    );
  }
}
