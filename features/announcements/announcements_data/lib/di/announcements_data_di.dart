import 'package:injectable/injectable.dart';
import '../src/announcements_remote_data_source.dart';

@InjectableInit.microPackage(
  throwOnMissingDependencies: true,
  ignoreUnregisteredTypes: [AnnouncementsRemoteDataSource],
)
void initAnnouncementsDataModule() {}
