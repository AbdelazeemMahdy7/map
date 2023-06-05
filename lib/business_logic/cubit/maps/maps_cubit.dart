import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/data/models/place.dart';
import 'package:maps/data/models/place_directions.dart';
import 'package:maps/data/models/place_suggestion.dart';
import 'package:maps/data/repository/maps_repository.dart';
import 'package:meta/meta.dart';
part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  final MapsRepository mapsRepository;

  MapsCubit(this.mapsRepository) : super(MapsInitial());

  void emitPlaceSuggestions(String place, String sessionToken) {
    mapsRepository.fetchSuggestions(place, sessionToken).then((suggestions) {
      emit(PlacesLoaded(suggestions));
    });
  }

  void emitPlaceLocation(String placeId, String sessionToken) {
    mapsRepository.getPlaceLocation(placeId, sessionToken).then((place) {
      emit(PlaceLocationLoaded(place));
    });
  }

  void emitPlaceDirections(LatLng origin, LatLng destination) {
    mapsRepository.getDirections(origin, destination).then((directions) {
      emit(DirectionsLoaded(directions));
    });
  }
}