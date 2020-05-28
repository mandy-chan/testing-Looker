view: dt_with_templated_filters {
view_label: "Testing out for Owen"
    derived_table: {
      sql: SELECT order_items.id AS id,
                  SUM(order_items.sale_price) AS total_sale_price,
                  AVG(order_items.sale_price) AS avg_sale_price,
                  MAX(returned_at) AS latest_date_returned,
                  MIN(returned_at) AS earliest_date_returned,
                  COUNT(*) AS count,
                  -1 as EthnicityKey,
                  returned_at
          -- OC Review 3/11/19: updated logic to populate filter suggestions.

           FROM demo_db.order_items  AS order_items
  --        WHERE returned_at >= {% date_start date_filter_name %}

          WHERE {% if dt_with_templated_filters.is_section8._is_filtered %} {% condition dt_with_templated_filters.is_section8 %} count {% endcondition %} {% else %} 1=1 {% endif %}

    ;;
    datagroup_trigger: looker_project_default_datagroup
    }


    filter: date_filter_name {
      type: date
    }

  dimension: is_section8 {
    type: yesno
    sql: ${TABLE}.id > 15 ;;
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

    measure: count {}

    filter: the_sales_price {
      type: number
    }

  filter: the_date_filter {
    type: string
    default_value: "1"
  }

  dimension: the_date {
    type: date
    sql: ${TABLE}.returned_at ;;
  }
}
