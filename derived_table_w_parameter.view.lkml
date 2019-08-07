view: derived_table_test_w_parameter {
  derived_table: {
    sql:
    SELECT
      {% parameter filter_name %} AS status,
      returned_at

      FROM demo_db.order_items  AS order_items
      LEFT JOIN demo_db.orders  AS orders ON order_items.id = orders.id
      LEFT JOIN demo_db.users  AS users ON orders.user_id = users.id


      LIMIT 500
       ;;
  }

  parameter: filter_name {
    type: unquoted
    allowed_value: {
      label: "Complete"
      value: "status" }
    allowed_value: {
      label: "Pending"
      value: "user_id" }
  }

  dimension: status {
    sql: ${TABLE}.status ;;
  }

  dimension: returned_at {
    type: date
    sql: ${TABLE}.returned_at
    ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

}
