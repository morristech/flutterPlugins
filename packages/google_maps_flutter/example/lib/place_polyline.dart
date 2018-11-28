import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'page.dart';

class PlacePolylinePage extends Page {
  PlacePolylinePage() : super(const Icon(Icons.map), 'Place polyline');

  @override
  Widget build(BuildContext context) {
    return const PlacePolylineBody();
  }
}

class PlacePolylineBody extends StatefulWidget {
  const PlacePolylineBody();

  @override
  State<StatefulWidget> createState() => PlacePolylineBodyState();
}

class PlacePolylineBodyState extends State<PlacePolylineBody> {
  PlacePolylineBodyState();

  GoogleMapController controller;
  int _polylineCount = 0;
  Polyline _selectedPolyline;

  int colorsIndex = 0;
  List<int> colors = [
    0xFF000000,
    0xFF2196F3,
    0xFFF44336,
  ];

  int widthsIndex = 0;
  List<double> widths = [10.0, 20.0, 5.0];

  int jointTypesIndex = 0;
  List<int> jointTypes = [JointType.mitered, JointType.bevel, JointType.round];

  int endCapsIndex = 0;
  List<Cap> endCaps = [Cap.buttCap, Cap.squareCap, Cap.roundCap];

  int startCapsIndex = 0;
  List<Cap> startCaps = [Cap.buttCap, Cap.squareCap, Cap.roundCap];

  int patternsIndex = 0;
  List<List<PatternItem>> patterns = [
    null,
    [
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
    [PatternItem.dash(30.0), PatternItem.gap(20.0)],
    [PatternItem.dot, PatternItem.gap(10.0)],
  ];

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
    controller.onPolylineTapped.add(_onPolylineTapped);
  }

  @override
  void dispose() {
    controller?.onPolylineTapped?.remove(_onPolylineTapped);
    super.dispose();
  }

  void _onPolylineTapped(Polyline polyline) {
    setState(() {
      _selectedPolyline = polyline;
    });
  }

  void _updateSelectedPolyline(PolylineOptions changes) {
    controller.updatePolyline(_selectedPolyline, changes);
  }

  void _add() {
    controller.addPolyline(PolylineOptions(
      consumeTapEvents: true,
      points: _createPoints(),
    ));
    setState(() {
      _polylineCount += 1;
    });
  }

  void _remove() {
    controller.removePolyline(_selectedPolyline);
    setState(() {
      _selectedPolyline = null;
      _polylineCount -= 1;
    });
  }

  Future<void> _toggleGeodesic() async {
    _updateSelectedPolyline(
      PolylineOptions(
          geodesic: !_selectedPolyline.options.geodesic,
          pattern: _selectedPolyline.options.pattern),
    );
  }

  Future<void> _toggleVisible() async {
    _updateSelectedPolyline(
      PolylineOptions(
          visible: !_selectedPolyline.options.visible,
          pattern: _selectedPolyline.options.pattern),
    );
  }

  Future<void> _changeColor() async {
    _updateSelectedPolyline(
      PolylineOptions(
          color: colors[++colorsIndex % colors.length],
          pattern: _selectedPolyline.options.pattern),
    );
  }

  Future<void> _changeWidth() async {
    _updateSelectedPolyline(
      PolylineOptions(
          width: widths[++widthsIndex % widths.length],
          pattern: _selectedPolyline.options.pattern),
    );
  }

  Future<void> _changeJointType() async {
    _updateSelectedPolyline(
      PolylineOptions(
          jointType: jointTypes[++jointTypesIndex % jointTypes.length],
          pattern: _selectedPolyline.options.pattern),
    );
  }

  Future<void> _changeEndCap() async {
    _updateSelectedPolyline(
      PolylineOptions(
          endCap: endCaps[++endCapsIndex % endCaps.length],
          pattern: _selectedPolyline.options.pattern),
    );
  }

  Future<void> _changeStartCap() async {
    _updateSelectedPolyline(
      PolylineOptions(
          startCap: startCaps[++startCapsIndex % startCaps.length],
          pattern: _selectedPolyline.options.pattern),
    );
  }

  Future<void> _changePattern() async {
    _updateSelectedPolyline(
      PolylineOptions(pattern: patterns[++patternsIndex % patterns.length]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 300.0,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              options: GoogleMapOptions(
                cameraPosition: const CameraPosition(
                  target: LatLng(52.4478, -3.5402),
                  zoom: 7.0,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('add'),
                          onPressed: (_polylineCount == 1) ? null : _add,
                        ),
                        FlatButton(
                          child: const Text('remove'),
                          onPressed:
                              (_selectedPolyline == null) ? null : _remove,
                        ),
                        FlatButton(
                          child: const Text('toggle visible'),
                          onPressed: (_selectedPolyline == null)
                              ? null
                              : _toggleVisible,
                        ),
                        FlatButton(
                          child: const Text('toggle geodesic'),
                          onPressed: (_selectedPolyline == null)
                              ? null
                              : _toggleGeodesic,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('change width'),
                          onPressed:
                              (_selectedPolyline == null) ? null : _changeWidth,
                        ),
                        FlatButton(
                          child: const Text('change start cap'),
                          onPressed: (_selectedPolyline == null)
                              ? null
                              : _changeStartCap,
                        ),
                        FlatButton(
                          child: const Text('change end cap'),
                          onPressed: (_selectedPolyline == null)
                              ? null
                              : _changeEndCap,
                        ),
                        FlatButton(
                          child: const Text('change joint type'),
                          onPressed: (_selectedPolyline == null)
                              ? null
                              : _changeJointType,
                        ),
                        FlatButton(
                          child: const Text('change color'),
                          onPressed:
                              (_selectedPolyline == null) ? null : _changeColor,
                        ),
                        FlatButton(
                          child: const Text('change pattern'),
                          onPressed: (_selectedPolyline == null)
                              ? null
                              : _changePattern,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<LatLng> _createPoints() {
    final List<LatLng> points = [];
    points.add(_createLatLng(51.4816, -3.1791));
    points.add(_createLatLng(53.0430, -2.9925));
    points.add(_createLatLng(53.1396, -4.2739));
    points.add(_createLatLng(52.4153, -4.0829));
    return points;
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }
}
