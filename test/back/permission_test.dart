import 'permissions.mocks.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

main() {
  MockPermissionsService mockPermissionsService = MockPermissionsService();

  group('domain/permission_test', () {
    test('bool getNetworkStatus, true, when we have internet', () async {
      when(mockPermissionsService.getNetworkStatus())
          .thenAnswer((_) async => true);
    });
    test('Future<Map<Permission, PermissionStatus>>  permissionServices', () {
      when(mockPermissionsService
          .permissionServices()
          .then((value) => value.isNotEmpty));

      reset(mockPermissionsService);
    });
  });
}
