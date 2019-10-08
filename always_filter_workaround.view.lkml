view: always_filter_workaround {
  sql_table_name: (SELECT * FROM demo_db.schema_migrations WHERE filename like "%add_item%")   ;;

  dimension: _filename {
    type: string
    sql: ${TABLE}.filename ;;
  }

  measure: count {
    label: " {{ _explore.name }}: COUNT"
    type: count
    drill_fields: [_filename]
  }
}
