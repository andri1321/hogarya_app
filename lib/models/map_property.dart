import 'package:app_hogar_ya/models/property.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProperty {
  final Property property;
  final LatLng position;

  MapProperty({
    required this.property,
    required this.position,
  });

  factory MapProperty.fromProperty(
    Property property, {
    LatLng? fallbackPosition,
  }) {
    final lat = property.latitude;
    final lng = property.longitude;

    if (lat != null && lng != null) {
      return MapProperty(
        property: property,
        position: LatLng(lat, lng),
      );
    }

    return MapProperty(
      property: property,
      position: fallbackPosition ?? const LatLng(19.4517, -70.6970),
    );
  }
}
