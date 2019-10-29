view: from_and_viewname {
  sql_table_name: demo_db.events ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
}
