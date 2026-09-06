# API Client

Small REST infrastructure for feature data packages. It declares low-level
request/interceptor contracts, provides HTTP/Chopper adapters, and converts
Chopper responses into typed `Result` values.

It owns **no cache, database, or offline policy**. Those choices stay visible
in each feature repository.

```dart
@GET(path: '/tasks')
Future<Response<dynamic>> tasks();

final result = await chopperResult(
  api.tasks,
  (json) => TaskDto.fromJson(json as Map<String, dynamic>),
);
```

Malformed JSON and mapper exceptions become `DecodeFailure`.

Data strategy:

- remote-only: call the generated API directly;
- short cache: wrap the remote call with `MemoryTtlCache`;
- offline-first: coordinate feature-owned local and remote datasources.

Firestore, Realtime Database, MongoDB, and local databases implement feature
datasource contracts directly; they do not pass through this package.

## Testing

```bash
dart test shared/api_client
```
