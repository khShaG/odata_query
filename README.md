# OData Query Builder

[![pub package](https://img.shields.io/pub/v/odata_query.svg)](https://pub.dev/packages/odata_query)

**OData Query Builder** is a simple Dart package designed for building OData query strings that you can concatenate to your REST API endpoints. It allows you to construct complex queries using a clean and declarative API, making it easy to interact with OData services.

## Features

- **Build OData Queries**: Create `$filter`, `$orderby`, `$select`, `$expand`, and more.
- **URL Encoding**: Automatically encodes query parameters for safe URL usage.
- **OData Query docs**: https://learn.microsoft.com/en-us/odata/concepts/queryoptions-overview

## Example

```dart
import 'package:odata_query/odata_query.dart';

void main() {
  final query = ODataQuery(
    filter: Filter.and(
      Filter.eq('Name', 'Milk'),
      Filter.lt('Price', 2.55),
    ),
    orderBy: OrderBy.desc('Price'),
    select: ['Name', 'Price'],
    expand: ['Category'],
    top: 10,
    count: true,
  ).build();

  print(query); 
  // Output:
  // "$filter=Name%20eq%20%27Milk%27%20and%20Price%20lt%202.55&$orderby=Price%20desc&$select=Name,Price&$expand=Category&$top=10&$count=true"
}
```
