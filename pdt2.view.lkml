view: pdt2 {

  derived_table: {
    sql: SELECT * FROM ${pdt1.SQL_TABLE_NAME}

      ;;
    persist_for: "1 hour"
    indexes: ["user_id"]

  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }
}
