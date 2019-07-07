- dashboard: merge
  title: Merge
  layout: newspaper
  elements:
  - title: Look Tile
    name: Look Tile
    model: looker_project
    explore: user_data
    type: looker_area
    fields: [users.age_tier, users.city, user_data.count]
    pivots: [users.age_tier]
    fill_fields: [users.age_tier]
    sorts: [user_data.count desc 0, users.age_tier]
    limit: 500
    series_types: {}
    row: 0
    col: 0
    width: 8
    height: 6
  - name: Merge results
    title: Merge results
    merged_queries:
    - model: looker_project
      explore: order_items
      type: table
      fields: [order_items.discounted_sale_price, order_items.count, users.age]
      sorts: [order_items.discounted_sale_price]
      limit: 500
      query_timezone: America/Los_Angeles
    - model: looker_project
      explore: order_items
      type: table
      fields: [users.age, users.email, users.count]
      sorts: [users.count desc]
      limit: 500
      query_timezone: America/Los_Angeles
      join_fields:
      - field_name: users.age
        source_field_name: users.age
    - model: looker_project
      explore: order_items
      type: table
      fields: [users.age, products.category, products.count]
      sorts: [products.count desc]
      limit: 500
      query_timezone: America/Los_Angeles
      join_fields:
      - field_name: users.age
        source_field_name: users.age
    type: table
    row: 0
    col: 8
    width: 8
    height: 6
  - name: add_a_unique_name_1561760792
    title: Check check check with Srinija
    model: looker_project
    explore: order_items
    type: looker_column
    fields: [orders.count_complete, orders.status, orders.this_month_incomplete_count]
    sorts: [orders.count_complete desc]
    limit: 500
    query_timezone: America/Los_Angeles
    series_types: {}
