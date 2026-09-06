# Service Catalog

Reference feature for **remote-only data**. Every repository read reaches the
remote datasource. Use this shape when stale data has no UX value and offline
availability is not required.

Reference feature for remote data with a short-lived memory cache. It has no
local datasource: cached values disappear when the repository or app restarts.

## Data flow

`Presentation -> Use case -> Repository -> RemoteDataSource`

`ServiceCatalogRepositoryImpl` keeps successful mapped entities for five
minutes. Pass `forceRefresh: true` to bypass the cache. Product apps implement
`ServiceCatalogRemoteDataSource` with a Chopper service and register it before
the feature DI initializer.

Use this pattern for searchable catalogs or reference data that remains safe to
lose. Do not add a database only to make the feature available offline.

Run `make codegen APP=sample_app`, then `make test APP=sample_app` after changes.
