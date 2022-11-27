import 'package:field_drawer/front/screens/map_screen.dart';
import 'package:field_drawer/front/screens/welcome_screen.dart';
import 'package:stacked/stacked_annotations.dart';

@StackedApp(routes: [
  MaterialRoute(page: WelcomeScreen, initial: true),
  MaterialRoute(page: MapScreen),
])
class App {
  /** This class has no puporse besides housing the
   * annotation that generates the required functionality **/
}
