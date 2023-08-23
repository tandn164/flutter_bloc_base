import 'package:flutter/material.dart';
import 'package:flutter_bloc_base/core/utils/constants.dart';
import 'package:flutter_bloc_base/core/utils/theme.dart';
import 'package:logging/logging.dart';
import 'core/utils/router.dart' as router;
import 'injection_container.dart' as di; //Dependency injector

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di
      .init(); //Inject all the dependencies and wait for it is done (i.e. UI won't built until all the dependencies are injected)
  _setupLogging();
  runApp(const CleanArchitectureWithBloc());
}

class CleanArchitectureWithBloc extends StatelessWidget {
  const CleanArchitectureWithBloc({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'clean architecture with bloc',
      theme: CustomTheme.mainTheme,
      onGenerateRoute: router.Router.generateRoute,
      initialRoute: LOGIN_ROUTE,
    );
  }
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

