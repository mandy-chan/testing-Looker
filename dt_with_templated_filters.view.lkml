view: dt_with_templated_filters {

    derived_table: {
      sql: SELECT order_items.id AS id,
                  SUM(order_items.sale_price) AS total_sale_price,
                  AVG(order_items.sale_price) AS avg_sale_price,
                  MAX(returned_at) AS latest_date_returned,
                  MIN(returned_at) AS earliest_date_returned,
                  returned_at

           FROM demo_db.order_items  AS order_items
           WHERE {% condition the_sales_price %} order_items.sales_price {% endcondition %}
           OR  {% condition the_date_filter %} order_items.returned_at {% endcondition %}

    ;;
    }

    dimension: id {
      type: number
      sql: ${TABLE}.id ;;
      primary_key: yes
    }

    dimension: total_sale_price {
      type: number
      sql: ${TABLE}.total_sale_price ;;
    }

    dimension: avg_sale_price {
      type: number
      sql: ${TABLE}.avg_sale_price ;;
    }

#     dimension: division {
#       type: number
#       sql: CASE WHEN ${total_sale_price} = 0
#                 THEN NULL
#                 ELSE ${avg_sale_price}/${total_sale_price}) * 100;;
#     }

    dimension: latest_date {
      type: date
      sql: ${TABLE}.latest_date_returned ;;
    }

    dimension: earliest_date {
      type: date
      sql: ${TABLE}.earliest_date_returned ;;
    }

    filter: the_sales_price {
      type: number
    }

  filter: the_date_filter {
    type: date
  }

  dimension: the_date {
    type: date
    sql: ${TABLE}.returned_at ;;
  }
}
