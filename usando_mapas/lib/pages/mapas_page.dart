import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapasPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapasPage({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  _MapasPageState createState() => _MapasPageState();
}

class _MapasPageState extends State<MapasPage> {
  final _controller = Completer<GoogleMapController>();
  StreamSubscription<Position>? _subscription;

  @override
  void initState() {
    super.initState();
    _monitorarLocalizacao();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Interno'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: {
          Marker(
            markerId: const MarkerId('1'),
            position: LatLng(widget.latitude, widget.longitude),
            infoWindow: const InfoWindow(
              title: 'Marcador 1',
            ),
          ),
          Marker(
            markerId: const MarkerId('2'),
            position: LatLng(widget.latitude + 0.01, widget.longitude + 0.01),
            infoWindow: const InfoWindow(
              title: 'Marcador 2',
            ),
          ),
          Marker(
            markerId: const MarkerId('3'),
            position: LatLng(widget.latitude - 0.01, widget.longitude - 0.01),
            infoWindow: const InfoWindow(
              title: 'Marcador 3',
            ),
          ),
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
      ),
    );
  }

  void _monitorarLocalizacao() {
    _subscription = Geolocator.getPositionStream(
      distanceFilter: 10,
      intervalDuration: const Duration(seconds: 1),
    ).listen((Position position) async {
      final controller = await _controller.future;
      final zoom = await controller.getZoomLevel();
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: zoom,
      )));
    });
  }
}
