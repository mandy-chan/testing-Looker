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

  measure: count_distinct_case_when_with_drill {
  type: count_distinct
  sql: CASE WHEN ${rank} >= 50000 THEN ${retail_price}
        ELSE NULL
        END ;;
  drill_fields: [products.category, products.rank, products.retail_price]
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    html: <p style="font-size:30px"> {{value}} </p> ;;
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
    value_format_name: usd
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
    html: <font size="18px">{{value}}</font> ;;
  }


  measure: average_retail_price {
    type: average
    sql: ${retail_price} ;;
    value_format_name: usd
  }

  measure: item_name_measure {
  type: string
  sql: max(${TABLE}.item_name);;
  }

  dimension: title {
    type: string
    sql: ${brand} ;;
    html: <h1>Sales on {{ rendered_value }} </h1> ;;
  }

}
