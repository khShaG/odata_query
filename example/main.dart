import 'package:odata_query/odata_query.dart';

void main() {
  // Build a query to filter products where the name is 'Milk' and price is less than 2.55.
  // Then order by 'Price' in descending order, retrieve the top 10, and include the total count.
  ODataQuery(
    filter: Filter.and(
      Filter.eq('Name', 'Milk'),
      Filter.lt('Price', 2.55),
    ),
    orderBy: OrderBy.desc('Price'),
    select: ['Name', 'Price'],
    expand: ['Category'], // Expanding related entities
    top: 10,
    count: true,
  ).build();

  // Result string:
  // "$filter=Name%20eq%20%27Milk%27%20and%20Price%20lt%202.55&$orderby=Price%20desc&$select=Name,Price&$expand=Category&$top=10&$count=true"

  // Another example with skip and search parameters
  ODataQuery(
    search: 'Bakery',
    top: 5,
    skip: 10,
    orderBy: OrderBy.asc('Name'),
  ).build();

  // Result string:
  // "$search=Bakery&$orderby=Name%20asc&$top=5&$skip=10"
}
