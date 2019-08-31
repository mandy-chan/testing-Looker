view: derived_table{
  derived_table: {
    sql:
    SELECT
      order_items.id as id,
      orders.status AS status,
      COUNT(*) AS count


     FROM demo_db.order_items AS order_items
     LEFT JOIN demo_db.orders AS orders ON order_items.id = orders.id
     LEFT JOIN demo_db.inventory_items AS inventory_items ON order_items.inventory_item_id = inventory_items.id
     LEFT JOIN demo_db.products AS products ON inventory_items.product_id = products.id

     GROUP BY 2
     LIMIT 500
       ;;
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

  dimension: status {
    sql: ${TABLE}.status;;
}

  measure: sum {
    type: sum
    sql: ${TABLE}.count ;;
  }

}
