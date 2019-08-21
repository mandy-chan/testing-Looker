view: test_derived_user_cohort {

  derived_table: {
    sql: SELECT users.id  AS user_id,
                products.brand AS products_brand
          FROM order_items
          LEFT JOIN orders ON order_items.order_id = orders.id
          LEFT JOIN inventory_items ON order_items.inventory_item_id = inventory_items.id
          LEFT JOIN products ON inventory_items.product_id = products.id
          LEFT JOIN users ON orders.user_id = users.id
          WHERE ({% condition cohort_filter_item_name %} products.item_name {% endcondition %})
            AND ({% condition cohort_filter_sku %} products.sku {% endcondition %} )
            AND ({% condition cohort_filter_brand_name %} products.brand {% endcondition %} )
          GROUP BY 1;;
  }

  dimension: user_id {
    hidden: no
    description: "Unique ID for each user that has ordered"
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: products_brand {
    type: string
    sql: ${TABLE}.products_brand ;;
  }

  filter: cohort_filter_sku {
    description: "SKU to filter cohort - filter on all users that purchased this sku"
    type: string
    suggest_explore: products
    suggest_dimension: products.sku
  }

  filter: cohort_filter_item_name {
    description: "Item Name to filter cohort - filter on all users that purchased this item"
    type: string
    suggest_explore: products
    suggest_dimension: products.item_name
  }

  filter: cohort_filter_brand_name {
    description: "Brand Name to filter cohort - filter on all users that purchased this brand"
    type: string
    suggest_explore: products
    suggest_dimension: products.brand_name
  }

}
