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

  measure: sum_retail_price {
    type: sum
    sql: ${products.retail_price} ;;
    html:
    {% if value >= median_sale_price._value %}
    <p style="background-color: pink">Cheap</p>
    {% elsif value >= median_sale_price._value}
    <p style="color: blue; font-size:80%">Moderate</p>
    {% else %}
    <p style="color: black; font-size:100%">Expensive</p>
    {% endif %};;
  }

  dimension: discounted_sale_price {
    type: number
    sql: ${sale_price} * 0.8 ;;
    value_format_name: usd
    html: <center>{{rendered_value}}</center>;;
  }

}
