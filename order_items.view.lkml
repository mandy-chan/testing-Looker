view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: liquid_date_returned {
    sql: ${returned_date} ;;
    html: <font color="green">{{rendered_value | date: "%U %B %D" }}</font> ;;
  }

# append: "-01"

  measure: last_updated_date {
    type: date
    sql: MAX(${returned_month}) ;;
    convert_tz: no
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: largest_order {
    type: max
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: median_sale_price {
    type: median
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: count {
    type: count
    drill_fields: [id, orders.id, inventory_items.id]
  }

  measure: count_with_filter {
    type: count
    drill_fields: [id, orders.id, inventory_items.id]
    html: <a href="{{ link }}&f[orders.id]=>100">{{ rendered_value }}</a> ;;
  }


  measure: sum_of_sale_price {
    type: sum
    sql: ${sale_price};;
    html:
    {% if value <= 250 and order_items.largest_order._in_query %}
      <p style="background-color: pink">{{rendered_value}}</p>
    {% elsif value > 250 and order_items.largest_order._in_query %}
      <p style="background-color: blue">{{rendered_value}}</p>
    {% else %}
      {{rendered_value}}
    {% endif %} ;;
  }

# {% if products.category._in_query and value >= 75000 %}
#               <font color="green">{{rendered_value}}</font>
#           {% elsif products.category._in_query and value >= 50000 and value < 75000 %}
#               <font color="goldenrod">{{rendered_value}}</font>
#           {% elsif products.category._in_query %}
#               <font color="red">{{rendered_value}}</font>
#           {% else %}
#               {{rendered_value}}
#           {% endif %}
#           ;;


  dimension: discounted_sale_price {
    type: number
    sql: ${sale_price} * 0.8 ;;
    value_format_name: usd
    html: <center>{{rendered_value}}</center>;;
  }

}
