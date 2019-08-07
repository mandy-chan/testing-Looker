view: dt_with_templated_filters {

    derived_table: {
      sql: SELECT order_items.id AS id,
                  SUM(order_items.sale_price) AS total_sale_price,
                  MAX(returned_at) AS latest_date_returned

           FROM demo_db.order_items  AS order_items
           WHERE {% condition the_sales_price %} order_items.sale_price {% endcondition %}
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

    dimension: latest_date {
      type: date
      sql: ${TABLE}.latest_date_returned ;;
    }

    filter: the_sales_price {
      type: number
    }
}
