import 'package:odata_query/odata_query.dart';

void main() {
  // Example 1: Build a query to filter products where the name is 'Milk' and price is less than 2.55.
  // Then order by 'Price' in descending order, select 'Name' and 'Price', expand the 'Category',
  // retrieve the top 10 items, and include the total count of records.
  final queryString = ODataQuery(
    filter: Filter.and(
      Filter.eq('Name', 'Milk'),
      Filter.lt('Price', 2.55),
    ),
    orderBy: OrderBy.desc('Price'),
    select: ['Name', 'Price'],
    expand: ['Category'], // Expanding related entities
    top: 10,
    count: true,
  ).toString();

  print('Query 1 (toString): $queryString');
  // Result:
  // "$filter=Name%20eq%20%27Milk%27%20and%20Price%20lt%202.55&$orderby=Price%20desc&$select=Name,Price&$expand=Category&$top=10&$count=true"

  // Example 2: Build a query to search for products in the 'Bakery' category,
  // return the top 5 results, skip the first 10 items, and order by 'Name' in ascending order.
  final queryMap = ODataQuery(
    search: 'Bakery',
    top: 5,
    skip: 10,
    orderBy: OrderBy.asc('Name'),
  ).toMap();

  print('Query 2 (toMap): $queryMap');
  // Result:
  // {
  //   '$search': "Bakery",
  //   '$orderby': "Name asc",
  //   '$top': "5",
  //   '$skip': "10"
  // }
}
