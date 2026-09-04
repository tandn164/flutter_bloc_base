# Profile Feature

Reusable profile loading, editing, and sign-out UI split into
`profile_domain`, `profile_data`, and `profile_presentation`.

The app owns route placement, session wiring, overlays, and any product-specific
profile actions. This feature exports Data, Domain and Presentation DI modules;
it is not enabled automatically in sample_app. See
[package-owned DI](../../tool/DEPENDENCY_INJECTION.md) for integration.
