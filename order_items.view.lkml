
view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  parameter: 2_or_5_sec {
    allowed_value: {
      label: "2 seconds"
      value: "2"
    }
    allowed_value: {
      label: "5 seconds"
      value: "5"
    }
    default_value: "30"
  }

  parameter: parameter_date {
    allowed_value: {
      label: "2019"
      value: "2019"
    }
  }

  dimension: abandonment_rate {
    sql: {% parameter 2_or_5_sec %}/ 100 ;;
  }


  dimension: inventory_item_id {
    type: number
    # hidden: yes
    link: {
      label: "is this working"
      url: "google.com"
    }
    required_access_grants: [access_grants_1]
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
    value_format_name: decimal_0
  }

  dimension_group: returned {
    type: time
    datatype: datetime
    timeframes: [ ]
    sql: ${TABLE}.returned_at ;;
  }

  filter: returned_filter {
    type: date
    sql: {% condition returned_filter %} ${returned_year} {% endcondition %} - DATE_SUB("2017-06-15", INTERVAL 2 YEARS); ;;
  }

  dimension: is_it_max_returned_week {
    type: yesno
    sql: ${returned_week} = ${derived_table.max_returned_week};;
  }

  dimension: duration_formatted {
    type: number
    sql: 100/86400 ;;
    value_format: "m:ss"
  }

  dimension_group: returned_fiscal {
    type: time
    timeframes: [fiscal_quarter, fiscal_quarter_of_year, fiscal_year]
    sql: ${TABLE}.returned_at ;;
  }

  measure: monthly_sales_price {
    type: sum
    sql: (${TABLE}.sale_price) ;;
    html:
    <a href="#drillmenu" target="_self">
       {% if value > users.percent_of_age %}

      {{ rendered_value }}
      {% else %}
      {{ rendered_value }}
    {% endif %}</a> ;;
  }




  measure: monthly_avg_per_day {
    type: sum
    sql: (${TABLE}.sale_price) / DAY(LAST_DAY(${TABLE}.returned_at)) ;;
  }

  dimension: liquid_variable_value {
    sql: ${products.brand} ;;
    html:
    {% if sale_price._value >= 10 AND sale_price._value <= 20 %}
    <font color="red">{{rendered_value}}</font>
    {% elsif sale_price.value > 20 AND sale_price._value <= 40 %}
    <font color="green">{{rendered_value}}</font>
    {% else %}
    <font color="blue">{{rendered_value}}</font>
    {% endif %} ;;
  }

  dimension: liquid_category_returned {
    sql: ${products.category};;
    link: {
      label: "Drill into charges"
      url:"https://www.google.com"
    }
    html:
    <a href="/dashboards/6?Liquid Category Returned={{ value | url_encode }}" target="_self">

    <font color="green">{{ products.category._value }}</font></a> ;;
  }

  dimension: removing_drills_if_under_different_model{
    type: string
    sql: ${products.category} ;;
#     html: {% if _model._name != 'looker_project' %}
#             "yes"
#           {% else %}
#             "no"
#           {% endif %} ;;
    link: {
      label: "Google 1"
      url: "{% if _model._name == 'looker_project' %}
            https://www.google.com={{ value }}

            {% endif %}"
    }
    link: {
      label: "Google 2"
      url: "https://www.google.com={{ value }}"
    }
  }

  measure: last_updated_date {
    type: date
    sql: MAX(${returned_month}) ;;
    convert_tz: no
  }

  # parameter: sale_price_metric_picker {
  #   description: "Use with the Sale Price Metric measure"
  #   type: unquoted
  #   allowed_value: {
  #     label: "Total Sale Price"
  #     value: "SUM"
  #   }
  #   allowed_value: {
  #     label: "Average Sale Price"
  #     value: "AVG"
  #   }
  #   allowed_value: {
  #     label: "Maximum Sale Price"
  #     value: "MAX"
  #   }
  #   allowed_value: {
  #     label: "Minimum Sale Price"
  #     value: "MIN"
  #   }
  # }

  # measure: sale_price_metric {
  #   type: number
  #   sql: {% parameter sale_price_metric_picker %}(${sale_price}) ;;
  # }

  dimension: hash {
    type: string
    sql: {% if _user_attributes['name_of_attribute'] == "Mandy" %}
    MD5(${TABLE}.sale_price)
    {% endif %} ;;
  }

  dimension: sale_price_with_format {
    type: number
    sql: ${TABLE}.sale_price*10000000 ;;
    value_format: "0"
  }

  filter: yesno_filter {
    type: string
    sql: {% condition yesno_filter %} ${sale_price} {% endcondition %}  ;;
  }

  dimension: tiering {
    type: number
    sql:  ${TABLE}.sale_price ;;
    html: {% if value < 1 %}
          <p style="color: black">LESS THAN 1</p>
          {% elsif value > 1 %}
          <p style="color: black">GREATER THAN 1</p>
          {% endif %} ;;
  }

  parameter: timeframe_picker {
    label: "Date Granularity"
    type: string
    allowed_value: { value: "YTD" }
    allowed_value: { value: "MTD" }
    default_value: "YTD"
  }

  dimension: is_YTD_day {
    group_label: "Days in MTD, QTD and YTD (excludes today)"
    label: "Is in YTD Dates (excludes today)"
    type: yesno
    sql:
      ${TABLE}.returned_at between CAST(DATE_ADD(CURDATE(), INTERVAL -12 MONTH) AS DATE) and CAST(CURDATE() AS DATE)
      ;;
  }

  dimension: is_MTD_day {
    group_label: "Days in MTD, QTD and YTD (excludes today)"
    label: "Is in MTD Dates (excludes today)"
    type: yesno
    sql: ${TABLE}.returned_at between DATE_FORMAT(NOW() ,'%Y-%M-01') AND NOW() ;;
  }

  dimension: dynamic_timeframe {
    type: string
    sql:
      CASE
      WHEN {% parameter timeframe_picker %} = 'YTD' AND ${is_YTD_day}='Yes' THEN 'No'
      WHEN {% parameter timeframe_picker %} = 'MTD' AND ${is_MTD_day}='Yes' THEN 'No'

      END ;;
  }

  # WHEN {% parameter timeframe_picker %} = 'QTD' THEN ${is_QTD_day_wtoday}='Yes'
  # WHEN{% parameter timeframe_picker %} = 'MTD' THEN ${is_MTD_day_wtoday}='Yes'

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd_0
  }

  measure: sum_of_sale_price {
    type: sum
    sql: COALESCE(${sale_price},0);;
    value_format_name: usd_0
    html:
    {% if value <= 250 and order_items.largest_order._in_query %}
      <p style="background-color: pink">{{rendered_value}}</p>
    {% elsif value > 250 and order_items.largest_order._in_query %}
      <p style="background-color: blue">{{rendered_value}}</p>
    {% else %}
      {{rendered_value}}
    {% endif %} ;;
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    html: {{ abandonment_rate._rendered_value }} || {{ rendered_value }} || {{ largest_order._rendered_value }} ;;
  }

  measure: percent_of_total {
    type: percent_of_total
    sql: ${total_sale_price};;
  }

  measure: largest_order {
    type: max
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: formatting {
    type: number
    sql:coalesce(1.0*${total_sale_price}/NULLIF(${order_id},0),0) ;;
    value_format: "0\%"

  }

  measure: division {
    type: number
    sql: CASE WHEN ${sale_price}/ ${largest_order} > 1 THEN  ${sale_price}/ ${largest_order}
         ELSE 0 END;;
    html:
    {% if value > 0 %}
    <font color="darkgreen"> + {{ rendered_value }}</font>
    {% else %}
    <font color="darkred">{{ rendered_value }}</font>
    {% endif %} ;;
  }

  measure: count {
    type: count
    link: {
      label: "testing out"
      url: "google.com"
    }
    drill_fields: [id, orders.id, inventory_items.id, products.category]
  }

# gives the link to the measure:count drill field

  measure: showing_all {
    type: count
    filters: [ returned_date: "-null"]
  }

  measure: count_with_filter {
    type: count
    drill_fields: [id, orders.id, inventory_items.id]
    html: <a href="{{ link }}&f[orders.id]=>100">{{ rendered_value }}</a> ;;
  }

  measure: cumulative_sale_price {
    type: running_total
    sql_distinct_key: ${orders.status} ;;
    sql: ${sum_of_sale_price} ;;
    value_format_name: usd
  }


# {% if products.category._in_query and value >= 75000 %}
#               <font color="green">{{rendered_value}}</font>
#           {% elsif products.category._in_query and value >= 50000 and value < 75000 %}
#               <font color="goldenrod">{{rendered_value}}</font>
#           {% elsif products.category._in_query %}
#               <font color="red">{{rendered_value}}</font>
#           {% else %}
#               {{rendered_value}}
#           {% endif %}
#           ;;


  dimension: discounted_sale_price {
    type: number
    sql: ${sale_price} * 0.8 ;;
    value_format_name: usd
    html: <center>{{rendered_value}}</center>;;
  }

# checking map layer

  dimension: zip_code_map_test {
    type: zipcode
    map_layer_name: chapter_01
    sql: 1=1;;
  }

}
