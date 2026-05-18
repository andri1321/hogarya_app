import 'package:app_hogar_ya/data/user_data.dart';
import 'package:app_hogar_ya/models/property.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileNavigation {
  ProfileNavigation._();

  static void openMyProfile(BuildContext context) {
    context.go('/profile');
  }

  static void openOwnerProfile(BuildContext context, Owner owner) {
    if (_isCurrentUser(owner)) {
      openMyProfile(context);
      return;
    }

    context.push(
      '/owner-profile',
      extra: owner,
    );
  }

  static bool _isCurrentUser(Owner owner) {
    return owner.id == UserData.userId || owner.name == UserData.userName;
  }

  static List<Property> propertiesForOwner(Owner owner) {
    return UserData.propertiesByOwner(owner);
  }
}
