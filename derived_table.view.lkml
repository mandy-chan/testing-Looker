view: derived_table{
  derived_table: {
    sql:
    SELECT
      order_items.id as id,
      order_items.returned_at as returned_at,
      products.brand as brand,


      AVG(products.retail_price) as avg_retail_price

--      DATE(MAX((DATE_FORMAT(TIMESTAMP(DATE(DATE_ADD(order_items.returned_at ,INTERVAL (0 - MOD((DAYOFWEEK(order_items.returned_at ) - 1) - 1 + 7, 7)) day))), '%Y-%m-%d'))) ) AS max_returned_week
--      CASE WHEN order_items.sale_price IS NOT NULL THEN SUM(order_items.sale_price)
--      ELSE NULL END AS net_revenue,
--      COUNT(*) AS count


     FROM demo_db.order_items AS order_items
     LEFT JOIN demo_db.orders AS orders ON order_items.id = orders.id
     LEFT JOIN demo_db.inventory_items AS inventory_items ON order_items.inventory_item_id = inventory_items.id
     LEFT JOIN demo_db.products AS products ON inventory_items.product_id = products.id

WHERE
{% if derived_table.brand_filter._is_filtered %}
{% if derived_table.order_filter._is_filtered %}

     {% condition derived_table.brand_filter %} products.brand {% endcondition %}
         or
     {% condition derived_table.order_filter %} order_items.id {% endcondition %}
  {% else %}
     {% condition derived_table.brand_filter %} products.brand {% endcondition %}
{% endif %}
{% elsif derived_table.order_filter._is_filtered %}
   {% condition derived_table.order_filter %} order_items.id {% endcondition %}
{% else %}
{% endif %}

    GROUP BY 1,2,3 ;;
  indexes: ["id"]
  }

  filter: brand_filter {
    type:  string
  }

  filter: order_filter {
    type: number

  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  measure: avg_retail_price {
    type: sum
    sql: ${TABLE}.avg_retail_price ;;
  }

  dimension: id {
    primary_key: yes
    sql: ${TABLE}.id ;;
}

  dimension: max_returned_week {
    sql: ${TABLE}.max_returned_week ;;
    type: date
  }

  dimension_group: returned {
    type: time
    timeframes: []
    sql: ${TABLE}.returned_at ;;
  }

  measure: count_distinct {
    type: count_distinct
    sql: CASE WHEN {% condition date_filter %} ${returned_date} {% endcondition %} THEN ${id} ELSE NULL END  ;;
  }

  filter: date_filter {}


#   dimension: net_revenue {
#     sql: ${TABLE}.net_revenue + 1;;
#   }
#
#   dimension: status {
#     sql: ${TABLE}.status;;
# }
#
#   measure: sum {
#     type: sum
#     sql: ${TABLE}.count ;;
#   }

}
