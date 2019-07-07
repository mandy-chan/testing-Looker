view: products {
  sql_table_name: demo_db.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;

  }

  dimension: category_to_google {
    type: string
    sql: ${TABLE}.category ;;
    html: <a href="https://google.com" target="_blank">{{value}}</a> ;;
  }

  dimension: category_with_link {
    type: string
    sql: ${TABLE}.category ;;
    html:  <a href="https://www.google.com/search?q={{value}}" target="_blank">{{ value }}</a> ;;
  }

  dimension: linking_with_link_parameter {
    type: string
    sql: ${TABLE}.category ;;
    link: {
      label: "Google Search"
      url: "https://www.google.com"
    }
  }

  dimension: linking_with_link_parameter_liquid {
    type: string
    sql: ${TABLE}.category ;;
    link: {
      label: "Google Search - {{value}}"
      url: "https://www.google.com/search?q={{value}}"
    }
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: rank_type {
    case: {
      when: {
        sql: ${rank} <= 500 ;;
        label: "low rank"
      }
      when: {
        sql: ${rank} <= 1000 ;;
        label: "moderate rank"
      }
      else: "high rank"

    }
  }

  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
  }

  measure: average_retail_price {
    type: average
    sql: ${retail_price} ;;
    value_format_name: usd
  }

  measure: gross_margin {
    type: number
    sql: ${retail_price} - ${inventory_items.cost} ;;
    value_format_name: usd
  }
}
