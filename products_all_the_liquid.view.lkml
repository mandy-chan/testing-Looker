view: products_all_the_liquid {
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
    html: <a href="/explore/looker_project/order_items?fields=products_all_the_liquid.brand_with_filterable_value,products.count&f[products.brand]={{filterable_value}}">~ {{ value }} ~</a> ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  filter: category_count_picker {
    description: "for templated filter"
    type: string
    suggest_dimension: products_all_the_liquid.category
  }

  measure: category_count {
    type: sum
    sql:
    CASE
      WHEN {% condition category_count_picker %} ${products_all_the_liquid.category} {% endcondition %}
      THEN 1
      ELSE 0
    END
  ;;
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

}
