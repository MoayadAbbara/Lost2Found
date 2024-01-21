import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapView extends StatefulWidget {
  final Function(double, double) onLocationSelected;

  const MapView({Key? key, required this.onLocationSelected}) : super(key: key);
  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng? _selectedLocation;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.19485219049501, 29.962355806215815),
    zoom: 12.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Map'),
        actions: [
          IconButton(onPressed: (){
            // Check if the location is selected
          if (_selectedLocation != null) {
            // Call the callback function with the selected location
            widget.onLocationSelected(
              _selectedLocation!.latitude,
              _selectedLocation!.longitude,
            );
            // Navigate back to the previous screen
            Navigator.pop(context);
          } else {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('No Location Selected'),
                  content: const Text('Please Select a Location'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
          }
          },
          icon: const Icon(Icons.check))
        ]
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (LatLng location) {
                setState(() {
                  _selectedLocation = location;
                });
              },
              markers: _selectedLocation != null
                  ? {
                      Marker(
                        markerId: const MarkerId('SelectedLocation'),
                        position: _selectedLocation!,
                        infoWindow: InfoWindow(
                          title: 'Selected Location',
                          snippet:
                              'Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}',
                        ),
                      ),
                    }
                  : {},
            ),
          ),
        ],
      ),
    );
  }
}