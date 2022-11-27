// import 'dart:collection';
//
// import 'package:field_drawer/domain/map_screen_vm.dart';
// import 'package:field_drawer/models/entry.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   var mapScreenVm = MapScreenVm();
//
//   group('domain/map_screen_vm', () {
//     test('void constructPolygon() check if polygon change ', () {
//       mapScreenVm.coordinates = [];
//       mapScreenVm.constructPolygon();
//       expect(mapScreenVm.polygon.isNotEmpty, true);
//     });
//
//     test('void toggleLayer() check if polygon was cleared ', () {
//       Set<Polygon> polygon = HashSet<Polygon>();
//       mapScreenVm.toggleLayer();
//       expect(polygon.isEmpty, true);
//     });
//
//     test('void toggleLayer() check if polygon was not cleared ', () {
//       Set<Polygon> polygon = HashSet<Polygon>();
//       mapScreenVm.toggleLayer();
//       polygon.add(Polygon(polygonId: PolygonId('1')));
//       expect(polygon.isEmpty, false);
//     });
//     test(' getAsset() convert json to String, correct type', () async {
//       var asset = await mapScreenVm
//           .getAssetString('assets/entries/entry_test.json');
//       expect(asset.runtimeType, String);
//     });
//     test(' getAsset() invalid return type ', () async {
//       var asset = mapScreenVm.getAssetString('assets/entries/entry_test.json');
//       expect(asset, isNot(String));
//     });
//
//     test('getEntry() convert json to entry', () async {
//       Entry entry = Entry.sample();
//       Entry result =
//           await mapScreenVm.getEntry('assets/entries/entry_test.json');
//
//       expect(result, entry);
//     });
//     test('getEntry() convert json to failed', () async {
//       Future<Entry> result =
//           mapScreenVm.getEntry('assets/entries/entry_test.json');
//
//       expect(result, isNot(Entry));
//     });
//   });
// }
