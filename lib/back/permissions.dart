import 'package:field_drawer/app/injection.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:permission_handler/permission_handler.dart';

@singleton
@GenerateNiceMocks([MockSpec<PermissionsService>()])
class PermissionsService {
  Permission permission = Permission.location;


  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    // You can request multiple permissions at once.
    late Map<Permission, PermissionStatus> statuses;
    try {
      statuses = await [
        Permission.location,
        ///if need, add more permission to request here.
      ].request();
    } on PlatformException catch(e){
      var logger = Logger();
      logger.d("permissionServices() PlatformException $e");
    }

    return statuses;
  }

  Future<bool> getNetworkStatus() async {
    final bool connectionStatus =
        await sL.get<InternetConnectionChecker>().hasConnection;
    return connectionStatus;
  }
}
