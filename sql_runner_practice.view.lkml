view: sql_runner_practice {
  derived_table: {
    sql: SELECT
        products.brand  AS `products.brand`,
        products.retail_price - inventory_items.cost  AS `products.gross_margin`
      FROM demo_db.order_items  AS order_items
      LEFT JOIN demo_db.inventory_items  AS inventory_items ON order_items.inventory_item_id = inventory_items.id
      LEFT JOIN demo_db.products  AS products ON inventory_items.product_id = products.id

      GROUP BY 1
      ORDER BY products.retail_price - inventory_items.cost  DESC
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: products_brand {
    type: string
    sql: ${TABLE}.`products.brand` ;;
  }

  dimension: products_gross_margin {
    type: number
    sql: ${TABLE}.`products.gross_margin` ;;
  }

  set: detail {
    fields: [products_brand, products_gross_margin]
  }
}
