import 'package:injectable/injectable.dart';
import 'package:announcements_domain/announcements_domain.dart';

@InjectableInit.microPackage(
    throwOnMissingDependencies: true,
    ignoreUnregisteredTypes: [AnnouncementsRepository])
void initAnnouncementsDomainModule() {}
