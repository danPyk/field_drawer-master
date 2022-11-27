import 'package:field_drawer/app/constans.dart';
import 'package:field_drawer/app/routes.router.dart';
import 'package:field_drawer/domain/map_screen_vm.dart';
import 'package:field_drawer/app/injection.dart';
import 'package:field_drawer/front/screens/signing/welcome.dart';
import 'package:field_drawer/front/screens/welcome_screen.dart';
import 'package:field_drawer/front/widgets/snackabr.dart';
import 'package:field_drawer/models/danger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:dropdown_search/dropdown_search.dart' as dropDown;
import 'package:searchable_listview/searchable_listview.dart';
import 'package:stacked_services/stacked_services.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  openDialogSearch(BuildContext context, MapScreenVm viewModel) {
    showAnimatedDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, bottom: 16.0, top: 32),
        child: Drawer(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,

            width: MediaQuery.of(context).size.width * 0.8,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchableList<Danger>.sliver(
                initialList: viewModel.dangerous,
                builder: (Danger city) => ListTile(
                  style: ListTileStyle.list,
                  title: Text(city.name),
                  subtitle: Text(city.town),
                ),
                filter: (value) => viewModel.dangerous
                    .where(
                      (element) => element.town.contains(value),
                    )
                    .toList(),
                // emptyWidget:  const EmptyView(),
                inputDecoration: InputDecoration(
                  labelText: "Type city to check if there's any danger.",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  openDialogNewDanger(BuildContext context, MapScreenVm viewModel) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              height: MediaQuery.of(context).size.height * 0.42,
              child: Dialog(
                backgroundColor: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Set danger name'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: viewModel.dangerNameController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Set dangerLevel'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: dropDown.DropdownSearch<String>(
                        popupProps: dropDown.PopupProps.menu(
                          showSelectedItems: true,
                          disabledItemFn: (String s) => s.startsWith('I'),
                        ),
                        items: viewModel.dangeresLevels,
                        dropdownDecoratorProps: dropDown.DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: "Select danger level",
                          ),
                        ),
                        onChanged: (String? selectedItem) =>
                            viewModel.selectedDangerLevel = selectedItem!,
                        selectedItem: "medium",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: OutlinedButton(
                                  onPressed: () async => {
                                        if (viewModel
                                                .dangerNameController.text ==
                                            "")
                                          {
                                            GlobalSnackBar.show(context,
                                                "Danger name can't be empty"),
                                          }
                                        else
                                          {
                                            Navigator.pop(context),
                                            await viewModel.saveDanger(),
                                          },
                                      },
                                  child: Text('Ok')),
                            ),
                            OutlinedButton(
                                onPressed: () => {
                                      viewModel.deleteDanger(context),
                                      Navigator.pop(context),
                                    },
                                child: Text('Cancel')),
                          ]),
                    ),
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapScreenVm>.reactive(
        viewModelBuilder: () => sL(),
        onModelReady: (model) async {},
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,

                ///hide back arrow
                backgroundColor: const Color(0xFF0F9D58),
                // title of app
                title: const Text("Danger Map"),
              ),
              drawer: Drawer(
                backgroundColor: const Color(0xFF0F9D58),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Text('Menu'  ,style: TextStyle(
                        fontSize: 22,
                        //COLOR DEL TEXTO TITULO
                        color: Colors.black,
                      ),),
                    ),
                    PhysicalShape(
                      color: Colors.green,
                      elevation: 18,
                      shadowColor: Colors.yellow,
                      clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: ListTile(
                        onTap: () async => {
                          await sL.get<SignOut>().signOut(),
                          Navigator.pushReplacementNamed(context, Welcome.id),
                        },
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 18,
                            //COLOR DEL TEXTO TITULO
                            color: Colors.black,
                          ),
                        ),
                        trailing: const Icon(Icons.logout),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: const Color(0xFF0F9D58),
                onPressed: () => openDialogSearch(context, viewModel),
                child: Icon(Icons.search),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.startFloat,
              // drawer: Drawer(
              //   // Add a ListView to the drawer. This ensures the user can scroll
              //   // through the options in the drawer if there isn't enough vertical
              //   // space to fit everything.
              //   child: ListView(
              //     // Important: Remove any padding from the ListView.
              //     padding: EdgeInsets.zero,
              //     children: [
              //       const DrawerHeader(
              //         decoration: BoxDecoration(
              //           color: Colors.blue,
              //         ),
              //         child: Text('Drawer Header'),
              //       ),
              //       ListTile(
              //         title: const Text('Add danger'),
              //         onTap: () {
              //           // Update the state of the app.
              //           Navigator.pop(context);
              //
              //           (BuildContext context) {
              //             showAnimatedDialog(
              //               context: context,
              //               barrierDismissible: true,
              //               builder: (BuildContext context) {
              //                 return Dialog(
              //                   child: Container(
              //                     height: 300,
              //                     width: 200,
              //                     child: Column(
              //                       children: <Widget>[
              //                         Text('Add danger'),
              //                         TextField(
              //                           controller: viewModel.dangerName,
              //                         ),
              //                         Text('Set dangerLevel'),
              //                         dropDown.DropdownSearch<String>(
              //                           popupProps: dropDown.PopupProps.menu(
              //                             showSelectedItems: true,
              //                             disabledItemFn: (String s) =>
              //                                 s.startsWith('I'),
              //                           ),
              //                           items: viewModel.dangeresLevels,
              //                           dropdownDecoratorProps:
              //                               dropDown.DropDownDecoratorProps(
              //                             dropdownSearchDecoration:
              //                                 InputDecoration(
              //                               hintText: "Select danger level",
              //                             ),
              //                           ),
              //                           onChanged: (String? selectedItem) =>
              //                               viewModel.danger.dangerLevel =
              //                                   selectedItem!,
              //                           selectedItem: "medium",
              //                         ),
              //                         Row(children: <Widget>[
              //                           OutlinedButton(
              //                               onPressed: () =>
              //                                   viewModel.addDanger(
              //                                       viewModel.selectedLatLng,
              //                                       viewModel.selectedTown,
              //                                       viewModel
              //                                           .selectedDangerLevel),
              //                               child: Text('Ok')),
              //                           OutlinedButton(
              //                               onPressed: () =>
              //                                   Navigator.pop(context),
              //                               child: Text('Cancel')),
              //                         ]),
              //                       ],
              //                     ),
              //                   ),
              //                 );
              //               },
              //               animationType: DialogTransitionType.size,
              //               curve: Curves.fastOutSlowIn,
              //               duration: Duration(seconds: 1),
              //             );
              //           };
              //
              //           // ...
              //         },
              //       ),
              //       ListTile(
              //         title: const Text('Item 2'),
              //         onTap: () {
              //           // Update the state of the app.
              //           Navigator.pop(context);
              //
              //           // ...
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: GoogleMap(
                        onTap: (LatLng point) {
                          viewModel.addMarker(point, context);
                          openDialogNewDanger(context, viewModel);
                          viewModel.dangerNameController.clear();
                        },
                        initialCameraPosition: viewModel.camPosition,
                        markers: viewModel.markers,
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        compassEnabled: true,
                        onMapCreated: (GoogleMapController controller) async {
                          viewModel.controller.complete(controller);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
