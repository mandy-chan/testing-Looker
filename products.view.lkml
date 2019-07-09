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

  dimension: brand_with_filterable_value{
    type: string
    sql: ${TABLE}.brand ;;
    html: <a href="/explore/looker_project/order_items?fields=products.brand_with_filterable_value,products.count&f[products.brand]={{filterable_value}}">{{ value }}</a> ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: category_user_attributes {
    type: string
    sql: ${TABLE}.category ;;
    html: {% if _user_attributes['company'] == 'Looker' %}
            <p style="color: #5A2FC2; background-color: #E5E5E6; font-size: 180%; font-weight: bold; text-align:center">{{value}}</p>
          {% else %}
            <p style="color: #166088; background-color: #43B7E7; font-size: 180%; font-weight: bold; text-align:center">{{value}}</p>
          {% endif %} ;;
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

  dimension: category_for_filter_dashboard {
    type: string
    sql: ${TABLE}.category ;;
    link: {
      label: "To Category"
      url: "/dashboards/6?Category={{ value | url_encode }}&Brand={{ _filters['products.brand'] | url_encode }}"
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
    value_format_name: usd
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
