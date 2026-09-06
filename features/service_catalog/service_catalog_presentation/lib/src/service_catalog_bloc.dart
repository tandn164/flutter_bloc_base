import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:service_catalog_domain/service_catalog_domain.dart';

import 'service_catalog_event.dart';
import 'service_catalog_state.dart';

export 'service_catalog_event.dart';
export 'service_catalog_state.dart';

@injectable
class ServiceCatalogBloc
    extends Bloc<ServiceCatalogEvent, ServiceCatalogState> {
  ServiceCatalogBloc(this._listItems) : super(const ServiceCatalogLoading()) {
    on<ServiceCatalogStarted>((event, emit) async {
      await _load(emit);
    });
    on<ServiceCatalogRefreshRequested>((event, emit) async {
      await _load(emit, forceRefresh: true);
    });
  }

  Future<void> _load(
    Emitter<ServiceCatalogState> emit, {
    bool forceRefresh = false,
  }) async {
    emit(const ServiceCatalogLoading());
    try {
      final items = await _listItems(forceRefresh: forceRefresh);
      if (!emit.isDone) emit(ServiceCatalogData(items));
    } catch (_) {
      if (!emit.isDone) {
        emit(const ServiceCatalogError('Unable to load items'));
      }
    }
  }

  final ListServiceCatalogItems _listItems;
}
