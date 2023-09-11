import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/location_provider.dart';

class MapScreen extends StatefulWidget {
  //const MapScreen({super.key});
  static const String id = 'map-screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: Center(
        child: Text('${locationData.latitude} : ${locationData.longitude}'),
      ),
    );
  }
}