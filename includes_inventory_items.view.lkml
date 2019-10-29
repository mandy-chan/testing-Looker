view: includes_inventory_items {
  sql_table_name: demo_db.inventory_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: order_items_sale_price_with_format {
    type: number
    sql: ${order_items.sale_price_with_format} ;;
  }
}
