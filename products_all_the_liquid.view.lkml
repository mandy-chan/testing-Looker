# using user attributes for dynamic schema and table name injection

view: products_all_the_liquid {
  sql_table_name: demo_db.{{ _user_attributes['custom_table'] }} ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    group_label: "Labeling"
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

  parameter: category_highlighting_datapoints {
    suggest_dimension: category
  }

  dimension: highlight_category {
    sql: CASE
         WHEN ${category} = {% parameter category_highlighting_datapoints %}
         THEN ${category}
    ELSE "other"
    END ;;
  }

  parameter: single_highlight_filter {
    suggest_dimension: category
  }

  dimension: single_highlight_if {
    type: string
    sql: {% if single_highlight_filter._parameter_value == '${category}' %}
             1
         {% else %}
             0
         {% endif %};;
  }

  dimension: single_highlight_case_when {
    sql: (case when {% parameter single_highlight_filter %} = ${category}
         then 1
         ELSE 0 END) ;;
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

  dimension: making_or_filters_with_different_fields  {
    type: yesno
    sql: {% condition or_filtering_field %} ${brand} {% endcondition %} OR
        {% condition or_filtering_field %} ${category} {% endcondition %};;
  }

  filter: or_filtering_field {
    type: string
    suggest_dimension: brand
  }

  parameter: filter_3_dimensions {
    allowed_value: {
      label: "Category"
      value: "1"
    }
    allowed_value: {
      label: "Category to Google"
      value: "2"
    }
  }

  dimension: dynamic_3_dimensions {
    type: string
    link: {
      label: "Category Filter"
      url: "https://localhost:9999/dashboards/11?Name%20of%20Category%20Filter={{ _filters['products_all_the_liquid.category'] | url_encode }}"
    }
    sql:
    CASE
    WHEN {% parameter filter_3_dimensions %} = '1' THEN ${category}
    WHEN {% parameter filter_3_dimensions %} = '2' THEN ${category_to_google}
    END ;;
  }

}
