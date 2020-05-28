
view: pdt1 {

  derived_table: {
    sql: SELECT
        user_id as user_id
        , COUNT(*) as lifetime_orders
        , MAX(orders.created_at) as most_recent_purchase_at
      FROM orders
      GROUP BY user_id
      ;;
#     persist_for: "1 hour"
#     indexes: ["user_id"]

  }

  dimension: user_id {
    label: "prefix"
    type: number
    sql: ${TABLE}.user_id ;;
    link: {
      label: "{{value}} Dashboard"
      url: "https://data.shinez.io/dashboards/15?Ad Name={{ value | encode_uri }}"
      icon_url: "https://shinez.io/favicon.ico"
    }
}

  dimension: lifetime_orders {
    sql: ${TABLE}.lifetime_orders ;;
  }
}
