view: inventory_items {
  sql_table_name:  demo_db.inventory_items ;;

  parameter: date_filter_start {
    type: date
  }

  parameter: date_filter_end {
    type: date
  }

  dimension: stringstring {
    type: string
    sql: "stringstring" ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
    label: "cost from 28 days"
  }

  dimension_group: created {
    type: time
    timeframes: []
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: time_between_created_and_sold{
   type: time
   sql: NOW() ;;
 }

  measure: created_measure {
    type: date_time
    sql: MAX(${created_raw}) ;;
  }

  measure: sold_measure {
    type: date_time
    sql: NOW() ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: sold {
    type: time
    timeframes: []
    sql: ${TABLE}.sold_at ;;
  }

  dimension_group: created_sold {
    type:  duration
    sql_start: ${created_raw} ;;
    sql_end: ${sold_raw} ;;
  }
  measure: count {
    type: count
    drill_fields: [id, products.id, products.item_name, order_items.count]
  }

  measure: most_recent_created_item {
    type:  date
    sql: MAX(${created_raw}) ;;
  }

  filter: testing_out_with_fields {
    type: string
    sql: ${TABLE}.date ;;
  }
}

#
#   {% assign datef_start = date_filter_start._parameter_value | date: "%Y-%m-%d" %}
#   {% assign datef_end = date_filter_end._parameter_value | date: "%Y-%m-%d" %}
#   {% assign epoch_now = "now" | date: "%s" %}
#   {% assign current = "now" | date: "%Y-%m-%d" %}
#   {% assign epoch_now_1_month_ago = epoch_now | minus: 2592000 %}
#   {% assign 1_month_ago = epoch_now_1_month_ago | date: "%Y-%m-%d" %}
#   {% if datef_start >= 1_month_ago %}
#     {% if datef_end <= current %}
#       {{ epoch_now }}
#     {% else %}
#       demo_db.inventory_items
#     {% endif %}
#   {% else %}
#       demo_db.inventory_items
#   {% endif %}
#   ;;
