# API Client Architecture

```mermaid
flowchart TD
  U[Feature use case] --> R[Feature repository]
  R --> S{Data strategy}
  S -->|No cache| API[Remote datasource / Chopper]
  S -->|Memory TTL| MC[MemoryTtlCache]
  MC --> API
  S -->|Offline-first| DB[Feature local datasource]
  R --> API
  API --> CR[chopperResult + safeDecode]
  CR --> RES[Result or typed Failure]
```

`api_client` ends at transport and decoding. It never decides whether data is
fresh, persistent, or available offline. That decision is part of the feature's
repository implementation, where a developer can see both data sources and the
merge behavior in one place.

Use the sample references:

- `service_catalog`: no cache;
- `announcements`: memory TTL cache;
- `work_orders`: offline-first local source of truth.
