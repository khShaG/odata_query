# OData Query Builder

[![pub package](https://img.shields.io/pub/v/odata_query.svg)](https://pub.dev/packages/odata_query)

**OData Query Builder** is a Dart package designed for building OData query strings that you can append to your REST API endpoints. It provides a clean, declarative API to construct complex queries efficiently.

## Features

- **Build Complex OData Queries**: Supports all key OData query options, including `$filter`, `$orderby`, `$select`, `$expand`, `$top`, `$skip`, and `$count`.
- **Programmatic Filter Construction**: Allows you to build OData filters with logical operations like `eq`, `lt`, `gt`, `and`, `or`, etc.
- **URL Encoding**: Automatically encodes query parameters for safe usage in URLs.
- **Map Conversion**: Convert query parameters into a `Map<String, String>` format for added flexibility when integrating with different APIs.
- **OData Query Documentation**: For detailed OData query options, refer to [OData Query Options Overview](https://learn.microsoft.com/en-us/odata/concepts/queryoptions-overview).

## Example

```dart
import 'package:odata_query/odata_query.dart';

void main() {
  // Example 1: Standard filter, orderBy, select, expand, top, and count
  final queryString = ODataQuery(
    filter: Filter.and(
      Filter.eq('Name', 'Milk'),
      Filter.lt('Price', 2.55),
    ),
    orderBy: OrderBy.desc('Price'),
    select: ['Name', 'Price'],
    expand: ['Category'],
    top: 10,
    count: true,
  ).toEncodedString();

  print(queryString); 
  // Output:
  // "$filter=Name%20eq%20'Milk'%20and%20Price%20lt%202.55&$orderby=Price%20desc&$select=Name,Price&$expand=Category&$top=10&$count=true"

  // Example 2: Filter with logical operators and select/expand parameters
  final queryMap = ODataQuery(
    filter: Filter.and(
      Filter.or(
        Filter.eq('Category', 'Beverages'),
        Filter.eq('Category', 'Snacks'),
      ),
      Filter.gt('Price', 5),
    ),
    select: ['Name', 'Price', 'Category'],
    expand: ['Supplier', 'Category'],
  ).toMap();

  print(queryMap);
  // Output:
  // {
  //   '$filter': "Category eq 'Beverages' or Category eq 'Snacks' and Price gt 5",
  //   '$select': 'Name,Price,Category',
  //   '$expand': 'Supplier,Category',
  // }

  // Example 3: Nested query - in parenthesis and separated by a colon.
  final queryNested = ODataQuery(
    select: ['Name', 'Price'],
    expand: [
      'Category(${ODataQuery(
        select: ['Type'],
      )};${ODataQuery(
        orderBy: OrderBy.asc('DateCreated'),
      )})',
    ],
  ).toString();

  print(queryNested); 
  // Output:
  // "$select=Name,Price&$expand=Category($select=Type;$orderby=DateCreated asc)"

  // Example 4: Using inList to filter with multiple values
  final queryInList = ODataQuery(
    filter: Filter.inList('Name', ['Milk', 'Cheese', 'Donut']),
    select: ['Name', 'Price'],
  ).toEncodedString();

  print(queryInList); 
  // Output:
  // "$filter=Name%20in%20('Milk'%2C%20'Cheese'%2C%20'Donut')&$select=Name%2CPrice"

  // Example 5: Using inCollection to filter using a collection reference
  final queryInCollection = ODataQuery(
    filter: Filter.inCollection('Name', 'RelevantProductNames'),
    select: ['Name', 'Price'],
  ).toEncodedString();

  print(queryInCollection); 
  // Output:
  // "$filter=Name%20in%20RelevantProductNames&$select=Name%2CPrice"

  // Example 6: Using any filter.
  final queryAny = ODataQuery(
    filter: Filter.any('Products', 'item', Filter.eq('item/Type', 'Active')),
  ).toEncodedString();

  print(queryAny);
  // Output:
  // "$filter=Products/any(item:item/Type eq 'Active')"

  // Example 7: Using all filter.
  final queryAll = ODataQuery(
    filter: Filter.all('Products', 'item', Filter.eq('item/Type', 'Active')),
  ).toEncodedString();

  print(queryAll);
  // Output:
  // "$filter=Products/all(item:item/Type eq 'Active')"
}

```


## API Overview

### ODataQuery
- search: Free-text search across multiple fields.
- filter: Allows filtering results based on conditions (e.g., eq, lt, gt).
- orderBy: Specify sorting (ascending or descending) on one or more fields.
- select: Select specific fields to reduce payload size.
- expand: Include related entities in the query response.
- top: Limit the number of records returned.
- skip: Skip a specified number of records (used for pagination).
- count: Whether to include the total count of matching records.

### Filter
- eq: Equality filter (e.g., Name eq 'Milk').
- ne: Non-equality filter.
- lt/gt: Less than / Greater than.
- le/ge: Less than or equal / Greater than or equal.
- and/or: Combine filters with logical and or or.

### OrderBy
- asc: Ascending sort.
- desc: Descending sort.
