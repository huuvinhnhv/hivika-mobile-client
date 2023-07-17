import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_cdtkpm_2023/Views/Nearby_Places/Directions.dart';
import '../../consts/images.dart';
import 'StoreInfo.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _selectedDistance = 1000;
  final LatLng _center = const LatLng(9.989124, 105.095854);
  late GoogleMapController _mapController;
  final List<Marker> _markers = [];
  final List<Polyline> _polylines = [];
  late DirectionsRepository directionsRepository;
  late Place? _selectedStore = null;
  final Set<Polyline> _polylinesFromUserToSelectedStore = {};
  final String apiKey = "AIzaSyCxSjy-xsHye33RinB_OdaFJY2smsgZGHg";

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  @override
  void initState() {
    super.initState();
    directionsRepository = DirectionsRepository(apiKey: apiKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
            markers: _markers.toSet(),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            circles: <Circle>{
              Circle(
                circleId: const CircleId('myCircle'),
                center: _center,
                radius: _selectedDistance.toDouble(),
                strokeWidth: 2,
                strokeColor: Colors.blue,
                fillColor: Colors.blue.withOpacity(0.1),
              ),
            },
            polylines: _selectedStore == null
                ? Set<Polyline>()
                : _polylinesFromUserToSelectedStore,
          ),
          Positioned(
            bottom: 10.0,
            left: 10.0,
            child: Container(
              width: MediaQuery.of(context).size.width - 20.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select Distance',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    DropdownButton(
                      value: _selectedDistance,
                      items: const [
                        DropdownMenuItem(
                          value: 500,
                          child: Text('Within 500 meters'),
                        ),
                        DropdownMenuItem(
                          value: 1000,
                          child: Text('Within 1 kilometer'),
                        ),
                        DropdownMenuItem(
                          value: 2000,
                          child: Text('Within 2 kilometers'),
                        ),
                        DropdownMenuItem(
                          value: 4000,
                          child: Text('Within 4 kilometers'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedDistance = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: _findNearestShop,
                      child: const Text('Find Nearest Shop'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: () {
                  _goToMyLocation();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  //test

  void _goToMyLocation() async {
    var position = await _determinePosition();
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15.0,
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
            'Location permissions are denied (but not permanently).');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _findNearestShop() async {
    // Get the user's current location
    Position currentPosition = await _determinePosition();

    // Calculate the distance from the user's current location to each shop location
    List<double> distances = [];
    for (Place place in places) {
      double distance = await Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        place.latitude,
        place.longitude,
      );
      distances.add(distance);
    }

    // Get the nearest shop location based on the selected distance
    List<Place> nearestShops = [];
    for (int i = 0; i < places.length; i++) {
      if (distances[i] <= _selectedDistance) {
        nearestShops.add(places[i]);
      }
    }

    // Clear the existing markers and polylines
    setState(() {
      _markers.clear();
      _polylines.clear();
    });

    // Add a marker for each nearest shop location and draw polyline
    if (nearestShops.isNotEmpty) {
      LatLngBounds bounds = _calculateBounds(
          nearestShops.map((e) => LatLng(e.latitude, e.longitude)).toList());
      for (Place place in nearestShops) {
        _addMarker(place);
      }
      _mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          bounds,
          100.0,
        ),
      );
    }
  }

  Future<void> _addMarker(Place place) async {
    final MarkerId markerId = MarkerId(place.id);

    final BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      icButtonHome04,
    );

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(place.latitude, place.longitude),
      infoWindow: InfoWindow(
        title: place.name,
        snippet: place.address,
      ),
      icon: customIcon,
      onTap: () {
        setState(() {
          _selectedStore = place;
          _getPolylineFromUserToSelectedStore(context);
        });
      },
    );

    setState(() {
      _markers.add(marker);
    });
  }

  Future<void> _getPolylineFromUserToSelectedStore(BuildContext context) async {
    Position userLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final LatLng userLatLng =
        LatLng(userLocation.latitude, userLocation.longitude);

    final Directions? directions = await directionsRepository.getDirections(
      origin: userLatLng,
      destination: LatLng(_selectedStore!.latitude, _selectedStore!.longitude),
    );

    if (directions != null) {
      final PolylineId polylineId = PolylineId('from_user_to_selected_store');
      final Polyline polyline = Polyline(
        polylineId: polylineId,
        color: Colors.red,
        width: 2,
        points: directions.polylinePoints,
      );

      setState(() {
        _polylinesFromUserToSelectedStore.add(polyline);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load directions'),
        ),
      );
    }
  }

  LatLngBounds _calculateBounds(List<LatLng> locations) {
    double minLat = locations[0].latitude;
    double maxLat = locations[0].latitude;
    double minLng = locations[0].longitude;
    double maxLng = locations[0].longitude;

    for (LatLng location in locations) {
      if (location.latitude < minLat) {
        minLat = location.latitude;
      }
      if (location.latitude > maxLat) {
        maxLat = location.latitude;
      }
      if (location.longitude < minLng) {
        minLng = location.longitude;
      }
      if (location.longitude > maxLng) {
        maxLng = location.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
//==============
}
