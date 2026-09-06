sealed class ServiceCatalogEvent {
  const ServiceCatalogEvent();
}

class ServiceCatalogStarted extends ServiceCatalogEvent {
  const ServiceCatalogStarted();
}

class ServiceCatalogRefreshRequested extends ServiceCatalogEvent {
  const ServiceCatalogRefreshRequested();
}
