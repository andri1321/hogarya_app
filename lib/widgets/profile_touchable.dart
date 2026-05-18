import 'package:app_hogar_ya/core/profile_navigation.dart';
import 'package:app_hogar_ya/models/property.dart';
import 'package:flutter/material.dart';

class ProfileTouchable extends StatelessWidget {
  final Owner owner;
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;

  const ProfileTouchable({
    super.key,
    required this.owner,
    required this.child,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius as BorderRadius? ?? BorderRadius.circular(0),
        onTap: () => ProfileNavigation.openOwnerProfile(context, owner),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}
