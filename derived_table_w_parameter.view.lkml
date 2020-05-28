view: derived_table_test_w_parameter {
  derived_table: {
    sql:
    SELECT
     brand,
     status,
     category

     FROM demo_db.order_items AS order_items
     LEFT JOIN demo_db.orders AS orders ON order_items.id = orders.id
     LEFT JOIN demo_db.inventory_items AS inventory_items ON order_items.inventory_item_id = inventory_items.id
     LEFT JOIN demo_db.products AS products ON inventory_items.product_id = products.id

     WHERE

{% if filter_name._parameter_value contains "," %}
brand="1"
 {% elsif filter_name._parameter_value contains "Last" %}
category

{% endif %}


LIMIT 10
;;
  }


    # brand = '{% parameter filter_name %}'
    # OR status like '"%client_acct_num":"{% parameter filter_name %}"'


  parameter: filter_name {
type: unquoted
   allowed_value: {
    label: ","
    value: "^,"
    }
    allowed_value: {
      label: "Last"
      value: "Last"
    }
  }

  dimension: status {
    sql: ${TABLE}.status ;;
  }

  dimension: category {
    sql: ${TABLE}.category ;;
  }

  dimension: brand {
    sql: ${TABLE}.brand ;;
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
