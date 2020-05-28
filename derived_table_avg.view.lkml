view: derived_table_avg {
  derived_table: {
    sql:
    SELECT

      AVG(products.retail_price) as avg_retail_price

     FROM demo_db.order_items AS order_items
     LEFT JOIN demo_db.orders AS orders ON order_items.id = orders.id
     LEFT JOIN demo_db.inventory_items AS inventory_items ON order_items.inventory_item_id = inventory_items.id
     LEFT JOIN demo_db.products AS products ON inventory_items.product_id = products.id
 ;;
  }

  dimension: avg_retail_price {
    sql: ${TABLE}.avg_retail_price ;;
    type: number
    link: {
      label: "retail price"
      url: "google.com"
    }
  }
  }
