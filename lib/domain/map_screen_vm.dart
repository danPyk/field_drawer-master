import 'dart:async';
import 'dart:collection';

import 'package:field_drawer/front/widgets/snackabr.dart';
import 'package:field_drawer/models/danger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:google_maps_webservice/places.dart';
import 'dart:convert';
import 'package:mockito/annotations.dart';
import 'package:dropdown_search/dropdown_search.dart' as dropDown;

@GenerateNiceMocks([MockSpec<MapScreenVm>()])
class MapScreenVm extends ChangeNotifier {
  ///map
  Completer<GoogleMapController> controller = Completer();
  final CameraPosition camPosition = const CameraPosition(
    target: LatLng(53.20127189893238, 16.39832562876689),
    zoom: 14,
  );

  Danger danger = Danger.empty();
  final Set<Marker> markers = {};

  var dangerNameController = TextEditingController();

  generateMarkers(BuildContext context) {
    notifyListeners();
  }

  List<String> dangeresLevels = ['Low', 'Medium', 'High'];
  List<Danger> dangerous = [];
  late String selectedTown;
  String selectedDangerLevel = 'medium';

  getPrediction(BuildContext context) async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: 'AIzaSyDB9DfFEwNp8iFXWm-PVm6JefCfpFM_n7A',
        mode: Mode.overlay,
        // Mode.fullscreen
        language: "fr",
        components: [Component(Component.country, "fr")]);
    return p;
  }

  late LatLng selectedLatLng;
  late Marker selectedMarker;
  Mode mode = Mode.overlay;

  late final ArgumentCallback<LatLng> onTap;
  final emptyMarker = Marker(
    //onTap: function,
    markerId: MarkerId('0'),
    position: LatLng(53.20127189893238, 16.39832562876689),
    infoWindow: InfoWindow(
      title: 'I am a marker',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
  );

  addMarker(LatLng point, BuildContext context) {
    selectedMarker = Marker(
      onTap: () => openDialogEditDanger(context, point),
      markerId: MarkerId(point.toString()),
      position: point,
      infoWindow: InfoWindow(
        title: dangerNameController.text,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
    );
    markers.add(selectedMarker);
    dangerNameController.clear();
    //

    notifyListeners();
  }

  deleteDanger(BuildContext context) {
    Marker marker = markers.firstWhere(
        (marker) => marker.markerId.value == selectedMarker.markerId.value,
        orElse: null);

    markers.remove(marker);

    notifyListeners();
  }

  saveDanger() async {
    Danger danger = Danger(
        id: selectedMarker.markerId.hashCode,
        town: await getTownFromCords(),
        marker: selectedMarker,
        dangerLevel: selectedDangerLevel,
        name: dangerNameController.text);

    dangerous.add(danger);
    notifyListeners();
  }

  Future<String> getTownFromCords() async {
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: selectedMarker.position.latitude,
        longitude: selectedMarker.position.longitude,
        googleMapApiKey: 'AIzaSyDB9DfFEwNp8iFXWm-PVm6JefCfpFM_n7A');

    return data.city;
  }
  late TextEditingController textEditingController;

  openDialogEditDanger(BuildContext context, LatLng latLng) {
    Danger findedElement =
        dangerous.where((element) => element.marker.position == latLng).first;
     textEditingController =
        TextEditingController(text: findedElement.name);
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,

            body: Dialog(
              backgroundColor: Colors.white,
              child: Container(
                height: 300,
                width: 200,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Modify danger name'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: textEditingController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Modify dangerLevel'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: dropDown.DropdownSearch<String>(
                          popupProps: dropDown.PopupProps.menu(
                            showSelectedItems: true,
                            disabledItemFn: (String s) => s.startsWith('I'),
                          ),
                          items: dangeresLevels,
                          dropdownDecoratorProps: dropDown.DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Modify danger level",
                            ),
                          ),
                          onChanged: (String? selectedItem) =>
                              danger.dangerLevel = selectedItem!,
                          selectedItem: selectedDangerLevel),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          OutlinedButton(
                              onPressed: () => {
                                    if (textEditingController.text == "")
                                      {
                                        GlobalSnackBar.show(
                                            context, "Danger name can't be empty"),
                                      }
                                    else
                                      {
                                        Navigator.pop(context),

                                        saveDanger(),

                                      }
                                  },
                              child: Text('Ok')),
                          OutlinedButton(
                              onPressed: () => {
                                    Navigator.pop(context),

                              },
                              child: Text('Cancel')),
                          OutlinedButton(
                              onPressed: () => {
                                    deleteDanger(context),
                                    Navigator.pop(context),
                                  },
                              child: Text('Delete')),
                        ]),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      animationType: DialogTransitionType.size,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );

  }
}
