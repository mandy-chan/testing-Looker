view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  parameter: aggregation {
    type: string
    allowed_value: { value: "Date" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Date"
  }

  dimension: aggregation_dimension {
    sql: {% parameter aggregation %}   ;;
  }

  dimension: dynamic_actual_departure_port_departed_on_utc {
    type: string
    sql:
      CASE
        WHEN {% parameter aggregation %} = 'Date' THEN ${created_date}
        WHEN {% parameter aggregation %} = 'Week' THEN ${created_week}
        WHEN {% parameter aggregation %} = 'Month' THEN ${created_month}
      END ;;
}

  dimension_group: created {
    view_label: "Desired Label"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: created_again {
    view_label: "Desired Label"
    type: time
    timeframes: [
      microsecond,
      fiscal_year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: status_filter {
    type: string
    sql: ${status} ;;
    suggestions: ["pending"]
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

  measure: count_cancelled_or_pending {
    label: "Cancelled or pending"
    type: count_distinct
    sql: CASE WHEN ${status} LIKE 'cancelled' OR ${status} LIKE 'pending' THEN ${TABLE}.id ELSE NULL END ;;
  }

  measure: count_complete {
    type: count_distinct
    sql:  ${user_id} ;;
    drill_fields: [id, users.id, users.first_name, users.last_name, order_items.count]
    filters: {
      field: is_order_paid
      value: "-NULL"
    }
  }

  measure: percent_completed_users {
    type: number
    sql: ${count_complete}/${count} * 1.0 ;;
  }


}
