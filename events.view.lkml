
view: events {
  sql_table_name: demo_db.events ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;

  }

  dimension: constant {
    type: number
    sql: CAST('0.01' as decimal) ;;
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

  dimension: type_id {
    type: number
    sql: ${TABLE}.type_id ;;

  }

  dimension: user_id {
    type: number

    sql: ${TABLE}.user_id ;;
  }

  dimension: value {
    type: string
    sql: ${TABLE}.value ;;

  }

  measure: count {
    type: count
    drill_fields: [id, users.id, users.first_name, users.last_name]
    filters: {
      field: created_date
      value: "7 days ago"
    }
  }

  measure: sum {
    type: sum

  }
}
