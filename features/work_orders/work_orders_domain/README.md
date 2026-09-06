# work_orders_domain

The domain package for the work_orders feature. See [feature usage](../README.md)
for the complete architecture and app wiring instructions.

## Dependency injection

This package owns `lib/di/work_orders_domain_di.dart`. Injectable generates the
adjacent `.module.dart` from constructor annotations. Importing the package
does not initialize DI; the app explicitly selects its module. Business classes
use constructor injection and can be instantiated directly in tests.

Run `make codegen APP=sample_app` from the workspace root after changing annotations.
Commit generated sources, including `.module.dart`; never edit them by hand.
Run package tests and the selected app tests before submitting changes.
