# Work Orders

Reference offline-first feature. Local storage is the source of truth; UI reads
its stream and never reads the remote datasource directly.

## Data flow

`Presentation -> Use cases -> Repository -> LocalDataSource + RemoteDataSource`

Writes update local state first and expose `pendingSync`. A successful remote
save clears that flag. `synchronize()` retries pending mutations, downloads
server data and updates local storage. Product apps should replace the bundled
key-value local datasource with Drift or another database when data is large,
relational, paginated or transaction-sensitive.

The sample intentionally keeps conflict resolution simple. Real features must
define server versioning, deletion tombstones, idempotency and merge rules.

Run `make codegen APP=sample_app`, then `make test APP=sample_app` after changes.
