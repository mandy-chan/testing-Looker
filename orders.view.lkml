view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: is_order_paid {
    type: yesno
    sql: ${status} = "complete" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.id, users.first_name, users.last_name, order_items.count]
  }

  measure: this_month_incomplete_count {
    label: "Customers who haven't paid"
    description: "Customers who haven't paid for their order within the past year"
    type: count_distinct
    sql: ${TABLE}.id ;;
    filters: {
      field: created_year
      value: "1 year"
    }
    filters: {
      field: status
      value: "-complete"
    }
  }

}
