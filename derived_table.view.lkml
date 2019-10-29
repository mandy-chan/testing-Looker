view: derived_table{
  derived_table: {
    sql:
    SELECT
      order_items.id as id,
      orders.status AS status,
      CASE WHEN order_items.sale_price IS NOT NULL THEN SUM(order_items.sale_price)
      ELSE NULL END AS net_revenue,
      COUNT(*) AS count


     FROM demo_db.order_items AS order_items
     LEFT JOIN demo_db.orders AS orders ON order_items.id = orders.id
     LEFT JOIN demo_db.inventory_items AS inventory_items ON order_items.inventory_item_id = inventory_items.id
     LEFT JOIN demo_db.products AS products ON inventory_items.product_id = products.id

     GROUP BY 2
     LIMIT 500
       ;;
  sql_trigger_value: SELECT CURDATE() ;;
  indexes: ["id"]
  }

  dimension: stringstring {
    type: string
    sql: "stringstring" ;;
  }

  dimension: id {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.id ;;
}

  dimension: net_revenue {
    sql: ${TABLE}.net_revenue + 1;;
  }

  dimension: status {
    sql: ${TABLE}.status;;
}

  measure: sum {
    type: sum
    sql: ${TABLE}.count ;;
  }

}
