import 'package:flutter_test/flutter_test.dart';
import 'package:odata_query/src/odata_query.dart';

void main() {
  group('ODataQuery', () {
    test('should create a query with filter and orderBy', () {
      final query = ODataQuery(
        filter: Filter.eq('Name', 'Milk'),
        orderBy: OrderBy.asc('Price'),
      ).toEncodedString();

      expect(query, r"$filter=Name%20eq%20'Milk'&$orderby=Price%20asc");
    });

    test('should include top and count in the query', () {
      final query = ODataQuery(
        top: 10,
        count: true,
      ).toString();

      expect(query, r'$top=10&$count=true');
    });

    test('should handle all query parameters', () {
      final query = ODataQuery(
        search: 'Milk',
        filter: Filter.and(
          Filter.eq('Name', 'Milk'),
          Filter.lt('Price', 2.55),
        ),
        orderBy: OrderBy.desc('Price'),
        select: ['Name', 'Price'],
        expand: ['Category'],
        top: 5,
        skip: 2,
        count: true,
      ).toEncodedString();

      expect(
        query,
        r"$search=Milk&$filter=Name%20eq%20'Milk'%20and%20Price%20lt%202.55&$orderby=Price%20desc&$select=Name%2CPrice&$expand=Category&$top=5&$skip=2&$count=true",
      );
    });

    test('should convert to map correctly', () {
      final queryMap = ODataQuery(
        filter: Filter.eq('Name', 'Milk'),
        top: 10,
      ).toMap();

      expect(queryMap, {
        r'$filter': "Name eq 'Milk'",
        r'$top': '10',
      });
    });

    test('should handle empty or null parameters', () {
      final query = ODataQuery().toEncodedString();
      expect(query, '');
    });

    test('should handle complex filters with both AND and OR', () {
      final query = ODataQuery(
        filter: Filter.and(
          Filter.or(
            Filter.eq('Category', 'Beverages'),
            Filter.eq('Category', 'Snacks'),
          ),
          Filter.gt('Price', 5),
        ),
      ).toEncodedString();

      expect(
        query,
        r"$filter=Category%20eq%20'Beverages'%20or%20Category%20eq%20'Snacks'%20and%20Price%20gt%205",
      );
    });

    test('should handle null filter values correctly', () {
      final query = ODataQuery(
        filter: Filter.eq('Name', null),
      ).toEncodedString();

      expect(query, r'$filter=Name%20eq%20null');
    });

    test('should handle multiple select fields', () {
      final query = ODataQuery(
        select: ['Name', 'Price', 'Category'],
      ).toEncodedString();

      expect(
        query,
        r'$select=Name%2CPrice%2CCategory',
      );
    });

    test('should handle multiple expand fields', () {
      final query = ODataQuery(
        expand: ['Category', 'Supplier'],
      ).toEncodedString();

      expect(
        query,
        r'$expand=Category%2CSupplier',
      );
    });

    test('should ignore empty or null select and expand', () {
      final query = ODataQuery(
        select: [],
        expand: null,
      ).toEncodedString();

      expect(query, '');
    });

    test('should handle skip without top', () {
      final query = ODataQuery(
        skip: 20,
      ).toEncodedString();

      expect(query, r'$skip=20');
    });
  });

  group('Filter', () {
    test('should create an eq filter', () {
      final filter = Filter.eq('Name', 'Milk').toString();
      expect(filter, "Name eq 'Milk'");
    });

    test('should create a lt filter', () {
      final filter = Filter.lt('Price', 2.55).toString();
      expect(filter, 'Price lt 2.55');
    });

    test('should combine filters using and', () {
      final filter = Filter.and(
        Filter.eq('Name', 'Milk'),
        Filter.lt('Price', 2.55),
      ).toString();

      expect(filter, "Name eq 'Milk' and Price lt 2.55");
    });

    test('should combine filters using or', () {
      final filter = Filter.or(
        Filter.eq('Name', 'Milk'),
        Filter.gt('Price', 1.5),
      ).toString();

      expect(filter, "Name eq 'Milk' or Price gt 1.5");
    });

    test('should handle special characters in strings', () {
      final filter = Filter.eq('Name', "O'Reilly").toString();
      expect(filter, "Name eq 'O''Reilly'");
    });

    test('should handle null value in eq filter', () {
      final filter = Filter.eq('Name', null).toString();
      expect(filter, 'Name eq null');
    });

    test('should handle null value in lt filter', () {
      final filter = Filter.lt('Price', null).toString();
      expect(filter, 'Price lt null');
    });
  });

  group('OrderBy', () {
    test('should create an asc order by clause', () {
      final orderBy = OrderBy.asc('Price').toString();
      expect(orderBy, 'Price asc');
    });

    test('should create a desc order by clause', () {
      final orderBy = OrderBy.desc('Price').toString();
      expect(orderBy, 'Price desc');
    });
  });
}
