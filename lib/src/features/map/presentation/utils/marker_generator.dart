import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../events/domain/event_model.dart';

class MarkerGenerator {
  static double getHue(EventType type) {
    switch (type) {
      case EventType.bhandara:
        return BitmapDescriptor.hueOrange;
      case EventType.langar:
        return BitmapDescriptor.hueGreen;
      case EventType.ngoCamp:
        return BitmapDescriptor.hueBlue;
      case EventType.templeMeal:
        return BitmapDescriptor.hueYellow;
      case EventType.lowCost:
        return BitmapDescriptor.hueCyan;
      case EventType.shopOpening:
        return BitmapDescriptor.hueViolet;
    }
  }

  static BitmapDescriptor getMarkerIcon(EventType type) {
     return BitmapDescriptor.defaultMarkerWithHue(getHue(type));
  }
}
