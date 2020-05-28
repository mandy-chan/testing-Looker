view: users_with_sql_always_filter {
  sql_table_name: demo_db.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: city {
    sql: ${TABLE}.city ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name]
  }
}
