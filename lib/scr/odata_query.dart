/// ODataQuery helps build OData query strings by combining various parameters
/// like $filter, $orderby, $select, and more in a declarative way.
///
/// Example:
/// ```dart
/// final query = ODataQuery(
///   filter: Filter.and(
///     Filter.eq('Name', 'Milk'),
///     Filter.lt('Price', 2.55),
///   ),
///   orderBy: OrderBy.desc('Price'),
///   top: 10,
///   count: true,
/// ).build();
///
/// print(query);
/// Output: "$filter=Name%20eq%20%27Milk%27%20and%20Price%20lt%202.55&$orderby=Price%20desc&$top=10&$count=true"
/// ```
class ODataQuery {
  ODataQuery({
    this.search,
    this.filter,
    this.orderBy,
    this.select,
    this.expand,
    this.top,
    this.skip,
    this.count,
  });

  final String? search;
  final Filter? filter;
  final OrderBy? orderBy;
  final List<String>? select;
  final List<String>? expand;
  final int? top;
  final int? skip;
  final bool? count;

  /// Builds the final OData query string by combining all provided options.
  /// It constructs a URL-friendly string with encoded values.
  ///
  /// Example:
  /// ```dart
  /// final query = ODataQuery(
  ///   filter: Filter.eq('Name', 'Milk'),
  ///   orderBy: OrderBy.asc('Price'),
  /// ).build();
  ///
  /// print(query);
  /// Output: "$filter=Name%20eq%20%27Milk%27&$orderby=Price%20asc"
  /// ```
  String build() {
    final Map<String, String> params = {
      if (search case final search?) r'$search': search,
      if (filter case final filter?) r'$filter': filter.toString(),
      if (orderBy case final orderBy?) r'$orderby': orderBy.toString(),
      if (select case final select? when select.isNotEmpty)
        r'$select': select.join(','),
      if (expand case final expand? when expand.isNotEmpty)
        r'$expand': expand.join(','),
      if (top case final top?) r'$top': top.toString(),
      if (skip case final skip?) r'$skip': skip.toString(),
      if (count case final count?) r'$count': count.toString().toLowerCase(),
    };

    if (params.isEmpty) {
      return '';
    }

    final queryString = params.entries
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
        .join('&');
    return queryString;
  }
}

/// The Filter class is used to construct OData $filter expressions programmatically.
/// It provides methods to create filters like eq (equals), ne (not equals), gt (greater than),
/// lt (less than), and allows combining filters using logical AND/OR.
///
/// Example:
/// ```dart
/// final filter = Filter.and(
///   Filter.eq('Name', 'Milk'),
///   Filter.lt('Price', 2.55),
/// );
///
/// print(filter.toString());
/// Output: "Name eq 'Milk' and Price lt 2.55"
/// ```
class Filter {
  Filter._(this.expression);

  final String expression;

  /// Creates an equality filter (e.g., "Name eq 'Milk'").
  static Filter eq(String field, dynamic value) =>
      Filter._('$field eq ${_encode(value)}');

  /// Creates a non-equality filter (e.g., "Name ne 'Milk'").
  static Filter ne(String field, dynamic value) =>
      Filter._('$field ne ${_encode(value)}');

  /// Creates a greater-than filter (e.g., "Price gt 2.55").
  static Filter gt(String field, dynamic value) =>
      Filter._('$field gt ${_encode(value)}');

  /// Creates a less-than filter (e.g., "Price lt 2.55").
  static Filter lt(String field, dynamic value) =>
      Filter._('$field lt ${_encode(value)}');

  /// Creates a greater-than or equal-to filter.
  static Filter ge(String field, dynamic value) =>
      Filter._('$field ge ${_encode(value)}');

  /// Creates a less-than or equal-to filter.
  static Filter le(String field, dynamic value) =>
      Filter._('$field le ${_encode(value)}');

  /// Combines two filters using a logical AND (e.g., "Name eq 'Milk' and Price lt 2.55").
  static Filter and(Filter left, Filter right) =>
      Filter._('${left.expression} and ${right.expression}');

  /// Combines two filters using a logical OR (e.g., "Name eq 'Milk' or Price lt 2.55").
  static Filter or(Filter left, Filter right) =>
      Filter._('${left.expression} or ${right.expression}');

  /// Helper method to encode values like strings or numbers.
  static String _encode(dynamic value) {
    if (value is String) {
      return "'${value.replaceAll("'", "''")}'";
    }
    return value.toString();
  }

  /// Converts the filter to a string for query usage.
  @override
  String toString() => expression;
}

/// The OrderBy class is used to create OData $orderby expressions, allowing sorting
/// by fields in either ascending or descending order.
///
/// Example:
/// ```dart
/// final orderBy = OrderBy.desc('Price');
/// print(orderBy.toString());
/// Output: "Price desc"
/// ```
class OrderBy {
  OrderBy._(this.expression);

  final String expression;

  /// Sorts results by a field in ascending order (e.g., "Price asc").
  static OrderBy asc(String field) => OrderBy._('$field asc');

  /// Sorts results by a field in descending order (e.g., "Price desc").
  static OrderBy desc(String field) => OrderBy._('$field desc');

  /// Converts the order-by clause to a string for query usage.
  @override
  String toString() => expression;
}
