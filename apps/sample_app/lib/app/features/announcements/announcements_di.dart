import 'package:announcements_data/di/announcements_data_di.module.dart';
import 'package:announcements_domain/di/announcements_domain_di.module.dart';
import 'package:announcements_presentation/di/announcements_presentation_di.module.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'announcements_di.config.dart';

@InjectableInit(
  initializerName: 'initAnnouncementsFeature',
  generateForDir: ['lib/app/features/announcements'],
  includeMicroPackages: false,
  externalPackageModulesBefore: [
    ExternalModule(AnnouncementsDataPackageModule),
    ExternalModule(AnnouncementsDomainPackageModule),
    ExternalModule(AnnouncementsPresentationPackageModule),
  ],
)
Future<void> registerAnnouncementsDependencies(GetIt container) =>
    container.initAnnouncementsFeature();
