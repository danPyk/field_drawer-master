import 'package:field_drawer/app/injection.dart';
import 'package:field_drawer/domain/welcome_screen_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WelcomeScreenVm>.reactive(
        viewModelBuilder: () => sL(),
        onModelReady: (model) async {
          await model.internetConnectionSnackbar();
          await model.checkLocationPermission();
        },
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text('Welcome'),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    ///hide button while granted permission
                    child: viewModel.reload == 1
                        ? Container()
                        : OutlinedButton(
                            key: Key('o1'),
                            onPressed: () async => {
                              viewModel.incrementReload(),
                              await viewModel.checkLocationPermission(),
                              viewModel.navigeteIfSecondTimeAskedForPermission(),

                            },
                            child: const Text('Reload page'),
                          ),
                  )
                ],
              ),
            ));
  }
}
