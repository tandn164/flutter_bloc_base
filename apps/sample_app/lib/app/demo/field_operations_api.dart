import 'package:announcements_data/announcements_data.dart';
import 'package:app_connectivity/app_connectivity.dart';
import 'package:service_catalog_data/service_catalog_data.dart';
import 'package:work_orders_data/work_orders_data.dart';

/// In-process backend used only by the executable sample.
///
/// Feature packages depend on datasource contracts, so product apps replace
/// this object with Chopper-backed implementations without changing domain,
/// presentation or repository coordination.
class FieldOperationsSampleApi
    implements
        ServiceCatalogRemoteDataSource,
        AnnouncementsRemoteDataSource,
        WorkOrdersRemoteDataSource {
  FieldOperationsSampleApi(this._connectivity);

  final ConnectivityHint _connectivity;
  final _orders = <WorkOrdersItemDto>[
    const WorkOrdersItemDto(id: 'wo-1', title: 'Inspect air conditioner'),
    const WorkOrdersItemDto(id: 'wo-2', title: 'Replace lobby sensor'),
  ];

  Future<void> _networkDelay() async {
    if (_connectivity.isSureOffline) {
      throw const FieldOperationsNetworkException();
    }
    await Future<void>.delayed(const Duration(milliseconds: 450));
  }

  @override
  Future<List<ServiceCatalogItemDto>> fetchCatalog() async {
    await _networkDelay();
    return const [
      ServiceCatalogItemDto(id: 'svc-1', title: 'Equipment inspection'),
      ServiceCatalogItemDto(id: 'svc-2', title: 'Preventive maintenance'),
      ServiceCatalogItemDto(id: 'svc-3', title: 'Emergency repair'),
    ];
  }

  @override
  Future<List<AnnouncementsItemDto>> fetchAnnouncements() async {
    await _networkDelay();
    return const [
      AnnouncementsItemDto(id: 'news-1', title: 'Safety checklist updated'),
      AnnouncementsItemDto(id: 'news-2', title: 'September maintenance window'),
      AnnouncementsItemDto(
          id: 'news-3', title: 'New incident escalation policy'),
    ];
  }

  @override
  Future<List<WorkOrdersItemDto>> fetchAll() async {
    await _networkDelay();
    return List.unmodifiable(_orders);
  }

  @override
  Future<WorkOrdersItemDto> save(WorkOrdersItemDto item) async {
    await _networkDelay();
    final saved = item.copyWith(pendingSync: false);
    final index = _orders.indexWhere((value) => value.id == saved.id);
    if (index < 0) {
      _orders.insert(0, saved);
    } else {
      _orders[index] = saved;
    }
    return saved;
  }
}

class FieldOperationsNetworkException implements Exception {
  const FieldOperationsNetworkException();
}
