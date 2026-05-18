import 'dart:io';

import 'package:app_hogar_ya/data/user_data.dart';
import 'package:app_hogar_ya/models/property.dart';
import 'package:app_hogar_ya/widgets/profile_touchable.dart';
import 'package:app_hogar_ya/widgets/property_social_actions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PropertyFeedCard extends StatelessWidget {
  final Property property;

  const PropertyFeedCard({
    super.key,
    required this.property,
  });

  ImageProvider _imageProvider(String image) {
    if (image.startsWith('http')) {
      return NetworkImage(image);
    }

    return FileImage(File(image));
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 320,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.image_not_supported_outlined,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 10),
            Text(
              'Imagen no disponible',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildImagePlaceholder();
    }

    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        height: 320,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            height: 320,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder();
        },
      );
    }

    final file = File(imageUrl);
    if (!file.existsSync()) {
      return _buildImagePlaceholder();
    }

    return Image.file(
      file,
      height: 320,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildImagePlaceholder();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: UserData.notifier,
      builder: (context, value, child) {
        final currentProperty =
            UserData.propertyById(property.id) ?? property;

        final isLiked = UserData.isLiked(currentProperty.id);
        final isFavorite = UserData.isFavorite(currentProperty.id);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  ProfileTouchable(
                    owner: currentProperty.owner,
                    borderRadius: BorderRadius.circular(12),
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: _imageProvider(currentProperty.owner.avatar),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentProperty.owner.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              currentProperty.city,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_horiz),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/property-details', extra: currentProperty),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _buildPropertyImage(currentProperty.images.isNotEmpty ? currentProperty.images.first : null),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => PropertySocialActions.toggleLike(currentProperty),
                    child: Row(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.black,
                        ),
                        const SizedBox(width: 4),
                        Text("${currentProperty.likes}"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  GestureDetector(
                    onTap: () {
                      PropertySocialActions.showCommentsModal(
                        context,
                        currentProperty,
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline),
                        const SizedBox(width: 4),
                        Text("${currentProperty.comments}"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  GestureDetector(
                    onTap: () {
                      PropertySocialActions.sharePost(
                        context,
                        currentProperty,
                      );
                    },
                    child: const Icon(Icons.send_outlined),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => UserData.toggleFavorite(currentProperty),
                    child: Icon(
                      isFavorite ? Icons.bookmark : Icons.bookmark_border,
                      color: isFavorite ? const Color(0xFFFF4D5A) : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
