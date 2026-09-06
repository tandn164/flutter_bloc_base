# Announcements

Reference feature for remote data backed by a short-lived memory cache. Cached
records disappear when the app process is killed.

## Data flow

`Presentation -> Use case -> Repository -> MemoryTtlCache / RemoteDataSource`

This is the reference feature for **short-lived memory cache**. The repository
owns a configurable TTL (10 minutes by default). Cache disappears when the app
process is killed; use the work-orders pattern when persistence is required.

The repository keeps the latest result for 10 minutes by default. A forced
refresh bypasses and replaces the cache. Product apps implement
`AnnouncementsRemoteDataSource` with Chopper, Firestore or another provider.

Use this pattern for news, recent history or content that should open quickly
but can be re-downloaded. Use a database-backed offline-first repository when
queries, transactions or local mutations are required.

Run `make codegen APP=sample_app`, then `make test APP=sample_app` after changes.
