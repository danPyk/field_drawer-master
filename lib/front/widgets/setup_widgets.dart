import 'package:field_drawer/app/injection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

void setupSnackbar() {
  final service = sL<SnackbarService>();

  /// Registers a config to be used when calling showSnackbar
  service.registerSnackbarConfig(SnackbarConfig(
    backgroundColor: Colors.white,
    textColor: Colors.white,
    titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
    mainButtonTextColor: Colors.black,
  ));
}

void setupErrorWidget() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    /// If we're in debug mode, use the normal error widget which shows the error message
    if (kDebugMode) {
      return ErrorWidget(details.exception);
    } else {
      return Container();
    }
  };
}
