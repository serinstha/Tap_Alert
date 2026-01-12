import 'package:college_project/applications/permission_utils/location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    on<LoadCurrentLocation>(_onLoadCurrentLocation);
  }

  Future<void> _onLoadCurrentLocation(
    LoadCurrentLocation event,
    Emitter<MapState> emit,
  ) async {
    emit(MapLoading());
    try {
      final position = await LocationService.getCurrentLocation();
      final location = LatLng(position.latitude, position.longitude);
      emit(MapLoaded(location));
    } catch (e) {
      emit(MapError("Error getting location: $e"));
    }
  }
}
