# Trina Grid Demo

Trying out the `trina_grid` package for better tablular data visualization in Flutter.

## Getting Started

More of my journey into exploring better-fitting options than the Flutter built-in `DataTable`.

This demo app generates some sample data representing people and adds a person (unbeknownst to the table-widget) every 5 seconds (and periodically purges some also).

The widget `MyTrinaTable` is a reasonably re-usable widget suitable for feeding table heading- & row-data (via `headingsSource` & `rowsSource`). 
- It assumes the parent widget will handle notifying of data-updates via `setState`/`notifyListeners`
- It is aimed at read-only data (i.e. not for interactive spreadsheet-like behaviour), such as that which may be arriving from an external source (e.g. an API response)

As ever, to run the demo:

```BASH
flutter run -d chrome
```

Richard
2025