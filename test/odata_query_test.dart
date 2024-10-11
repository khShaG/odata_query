import 'package:flutter_test/flutter_test.dart';
import 'package:odata_query/scr/odata_query.dart';

void main() {
  group('ODataQuery Tests', () {
    test('Builds a query with only filter and orderBy', () {
      final query = ODataQuery(
        filter: Filter.and(
          Filter.eq('Name', 'Milk'),
          Filter.lt('Price', 2.55),
        ),
        orderBy: OrderBy.desc('Price'),
      ).build();

      expect(query,
          r'$filter=Name%20eq%20%27Milk%27%20and%20Price%20lt%202.55&$orderby=Price%20desc');
    });

    test('Builds a query with top, count, and skip', () {
      final query = ODataQuery(
        top: 10,
        skip: 5,
        count: true,
      ).build();

      expect(query, r'$top=10&$skip=5&$count=true');
    });

    test('Builds a query with \$select and \$expand', () {
      final query = ODataQuery(
        select: ['Name', 'Price'],
        expand: ['Category', 'Supplier'],
      ).build();

      expect(query, r'$select=Name,Price&$expand=Category,Supplier');
    });

    test('Builds a query with all parameters', () {
      final query = ODataQuery(
        search: 'Milk',
        filter: Filter.eq('Name', 'Milk'),
        orderBy: OrderBy.asc('Price'),
        select: ['Name', 'Price'],
        expand: ['Category'],
        top: 5,
        skip: 2,
        count: true,
      ).build();

      expect(
        query,
        r'$search=Milk&$filter=Name%20eq%20%27Milk%27&$orderby=Price%20asc&$select=Name,Price&$expand=Category&$top=5&$skip=2&$count=true',
      );
    });

    test('Returns empty string when no parameters provided', () {
      final query = ODataQuery().build();
      expect(query, '');
    });
  });

  group('Filter Tests', () {
    test('Creates eq filter correctly', () {
      final filter = Filter.eq('Name', 'Milk');
      expect(filter.toString(), "Name eq 'Milk'");
    });

    test('Creates ne filter correctly', () {
      final filter = Filter.ne('Name', 'Bread');
      expect(filter.toString(), "Name ne 'Bread'");
    });

    test('Creates gt filter correctly', () {
      final filter = Filter.gt('Price', 10);
      expect(filter.toString(), 'Price gt 10');
    });

    test('Creates lt filter correctly', () {
      final filter = Filter.lt('Price', 5.5);
      expect(filter.toString(), 'Price lt 5.5');
    });

    test('Creates ge filter correctly', () {
      final filter = Filter.ge('Rating', 4);
      expect(filter.toString(), 'Rating ge 4');
    });

    test('Creates le filter correctly', () {
      final filter = Filter.le('Rating', 2.3);
      expect(filter.toString(), 'Rating le 2.3');
    });

    test('Combines two filters with AND', () {
      final filter = Filter.and(
        Filter.eq('Name', 'Milk'),
        Filter.lt('Price', 2.55),
      );
      expect(filter.toString(), "Name eq 'Milk' and Price lt 2.55");
    });

    test('Combines two filters with OR', () {
      final filter = Filter.or(
        Filter.gt('Rating', 4),
        Filter.lt('Price', 3.5),
      );
      expect(filter.toString(), 'Rating gt 4 or Price lt 3.5');
    });
  });

  group('OrderBy Tests', () {
    test('Creates asc orderBy correctly', () {
      final orderBy = OrderBy.asc('Name');
      expect(orderBy.toString(), 'Name asc');
    });

    test('Creates desc orderBy correctly', () {
      final orderBy = OrderBy.desc('Price');
      expect(orderBy.toString(), 'Price desc');
    });
  });

  group('ODataQuery Special Cases', () {
    test('Correctly handles single quotes in filter', () {
      final query = ODataQuery(
        filter: Filter.eq('Name', "O'Reilly"),
      ).build();

      expect(query, r'$filter=Name%20eq%20%27O%27%27Reilly%27');
    });

    test('Correctly handles spaces in search', () {
      final query = ODataQuery(
        search: 'Milk and Eggs',
      ).build();

      expect(query, r'$search=Milk%20and%20Eggs');
    });

    test('Handles boolean filter values', () {
      final query = ODataQuery(
        filter: Filter.eq('IsActive', true),
      ).build();

      expect(query, r'$filter=IsActive%20eq%20true');
    });

    test('Handles numeric values correctly in filters', () {
      final query = ODataQuery(
        filter: Filter.gt('Age', 25),
      ).build();

      expect(query, r'$filter=Age%20gt%2025');
    });
  });
}
