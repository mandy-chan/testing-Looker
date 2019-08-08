view: always_filter_workaround {
  sql_table_name: (SELECT * FROM demo_db.schema_migrations WHERE filename like "%add_item%")   ;;

  dimension: filename {
    type: string
    sql: ${TABLE}.filename ;;
  }

  measure: count {
    type: count
    drill_fields: [filename]
  }
}
