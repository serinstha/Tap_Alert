import 'package:college_project/map/map_bloc/map_bloc.dart';
import 'package:college_project/map/map_bloc/map_event.dart';
import 'package:college_project/map/map_bloc/map_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapBloc()..add(LoadCurrentLocation()),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {
              if (state is MapLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is MapLoaded) {
                return FlutterMap(
                  options: MapOptions(
                    initialCenter: state.currentLocation,
                    initialZoom: 13.0,
                    maxZoom: 18.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.college_project',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: state.currentLocation,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else if (state is MapError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
