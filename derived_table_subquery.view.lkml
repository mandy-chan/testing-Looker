view: derived_table_subquery {
  derived_table: {
    sql_trigger_value: SELECT FLOOR(EXTRACT(epoch from NOW()) / (12*60*60)) ;;
    sql:
--    WITH experiment_data AS
    SELECT id FROM ${order_items.SQL_TABLE_NAME} ;;
  }

  dimension: id {
  sql: ${TABLE}.id ;;
  primary_key: yes
  }


}
