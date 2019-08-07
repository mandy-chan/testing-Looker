view: inventory_items {
  sql_table_name: demo_db.inventory_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension_group: created {
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
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
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
}
