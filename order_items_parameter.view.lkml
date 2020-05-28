view: order_items_parameter {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at;;
  }

  parameter: date_granularity {
    type: unquoted
    default_value: "Testing_this_out"
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    allowed_value: { value: "Quarter" }
    allowed_value: { value: "Year" }
  }

  dimension: invoice_created_at_filter {
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
    ${returned_date}
    {% endif %};;
  }

 dimension: batch_categories_dynamic_same_store {
  type: string
  sql:{% if order_items_parameter.date_granularity._parameter_value == 'Day' %}
      ${returned_date}
      {% elsif order_items_parameter.date_granularity._parameter_value == 'Week' %}
      ${returned_week}
      {% else %}
      null
      {% endif %} ;;
}


  parameter: sale_price_metric_picker {
    description: "Use with the Sale Price Metric measure"
    type: unquoted
    allowed_value: {
      label: "Total Sale Price"
      value: "SUM"
    }
    allowed_value: {
      label: "Average Sale Price"
      value: "AVG"
    }
    allowed_value: {
      label: "Maximum Sale Price"
      value: "MAX"
    }
    allowed_value: {
      label: "Minimum Sale Price"
      value: "MIN"
    }
  }

  measure: sale_price_metric {
    type: number
    sql: {% parameter sale_price_metric_picker %}(${sale_price}) ;;
  }

  measure: type_number {
    type: number
    sql: ${sale_price} ;;
    drill_fields: [id]
    html: <a href="{{ link }}"> {{ sale_price._linked_value }} {{ rendered_value }} </a>;;

  }

  parameter: last_x_days {
    type: unquoted
    allowed_value: {
      label: "7"
      value: "7"
    }
  }

  filter: dynamically_filter {
    type: number
  }

#   dimension: preset_list {
#     sql:
#     {% if last_x_days._parameter_value == '7' }
#     ((( ${order_items_parameter.returned_date}) >= ((DATE_ADD(CURDATE(),INTERVAL {% parameter last_x_days %} day))) AND (${order_items_parameter.returned_date}) < ((DATE_ADD(DATE_ADD(CURDATE(),INTERVAL {% parameter last_x_days %} day),INTERVAL {% parameter last_x_days %} day)))))
#     {% else %}
#     NULL
#     {% endif %};;
#   }
#
#   {% if order_items_parameter.date_filter._is_filtered %}
# --  ${order_items_parameter.returned_month}
#   {% condition order_items_parameter.date_filter %} ${order_items_parameter.returned_date} {% endcondition %}
#   {% else %}
#   ${order_items_parameter.returned_date} = (SELECT max(returned_at) FROM demo_db.order_items)
#   {% endif %}

  parameter: date_type {
    type: string
    allowed_value: {
      label: "day"
      value: "day"
    }
    allowed_value: {
      label: "month"
      value: "month"
    }
    allowed_value: {
      label: "ALL"
      value: ""
    }
  }

  filter: date_filter {
    type:  date
    required_fields: [returned_date]
  }

  filter: dynamic_filtered_measure_filter {
    type: number
    suggest_dimension: sale_price
  }

  dimension: dynamic_filtered_measure_dimension {
    type: yesno
    sql: {% condition dynamic_filtered_measure_filter %} ${sale_price} {% endcondition %}  ;;
  }

  measure: dynamic_filtered_measure_measure {
    type: count
    filters: {
      field: dynamic_filtered_measure_dimension
      value: "Yes"
    }
  }

  measure: count_yes_id {
    type: count_distinct
    sql: CASE WHEN {% condition date_filter %} ${returned_date} {% endcondition %} THEN ${id} ELSE NULL END  ;;
  }

  parameter: end_user_date {
    type: date
    }

  dimension: beginning_date_to_this_date {
    type: string
    sql:
    CASE WHEN
    ${returned_date} BETWEEN CAST('2017-01-01' AS DATE) AND LAST_DAY(DATE_SUB( {{ end_user_date._parameter_value }}, INTERVAL 1 MONTH))
    THEN "Yes"
    ELSE "No"
    END ;;
    }

  dimension: last_day_logic {
    type: string
    sql: LAST_DAY(DATE_SUB( {{ end_user_date._parameter_value }}, INTERVAL 1 MONTH)) ;;
  }

  dimension: lastmonth_or_thismonth {
    type: string
    sql:
    CASE WHEN EXTRACT(DAY FROM {{ end_user_date._parameter_value }} ) = 1
    THEN
      CASE WHEN ${returned_raw} BETWEEN CAST(CONCAT(EXTRACT(YEAR FROM {{ end_user_date._parameter_value }} ),"-",
                                        EXTRACT(MONTH FROM {{ end_user_date._parameter_value }} )-1,"-", 1) AS DATE)
                                        AND {{ end_user_date._parameter_value }}
      THEN "Yes"
      ELSE "No"
      END
    ELSE
     CASE WHEN ${returned_raw} BETWEEN CAST(CONCAT(EXTRACT(YEAR FROM {{ end_user_date._parameter_value }} ),"-",
                                        EXTRACT(MONTH FROM {{ end_user_date._parameter_value }} ),"-", 1) AS DATE)
                                          AND LAST_DAY( {{ end_user_date._parameter_value }} )
      THEN "Yes"
      ELSE "No"
      END
    END ;;
    }

  dimension: lastmonth_or_thismonth_2 {
    type: string
    sql:
    CASE WHEN EXTRACT(DAY FROM {{ end_user_date._parameter_value }} ) = 1
    THEN
      CASE WHEN ${returned_raw} BETWEEN CAST(CONCAT(EXTRACT(YEAR FROM ${returned_raw}),"-",
                                        EXTRACT(MONTH FROM ${returned_raw})-1,"-", 1) AS DATE)
                                        AND {{ end_user_date._parameter_value }}
      THEN "Yes"
      ELSE "No"
      END
    ELSE
     CASE WHEN ${returned_raw} BETWEEN CAST(CONCAT(EXTRACT(YEAR FROM ${returned_raw}),"-",
                                        EXTRACT(MONTH FROM ${returned_raw}),"-", 1) AS DATE)
                                          AND LAST_DAY( {{ end_user_date._parameter_value }} )
      THEN "Yes"
      ELSE "No"
      END
    END ;;
  }

  dimension: enddate_match {
    type: yesno
    sql: {% if order_items_parameter.returned_date._in_query %}
        ${returned_date} >= DATE_SUB({% date_end returned_date %}, INTERVAL 1 day) AND ${returned_date} < {% date_end returned_date %}
        {% else %}
         1=1
        {% endif %} ;;
  }

  dimension: filter_at_date {
    sql:
    {% if date_type._parameter_value == "'day'" %}
    ${returned_date}
    {% elsif date_type._parameter_value == "'month'" %}
    ${returned_month}
    {% elsif date_type._parameter_value == '' %}
    ${returned_date}

    {% else %}
    null
    {% endif %} ;;
  }

  dimension: filter_at_date_2 {
    sql:
    {% if date_type._parameter_value == '' %}
    ${returned_month}
    {% else %}
    null
    {% endif %} ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE};;
  }

  dimension: testing_out_value_with_hello {
    description: "ag_name.description"
    type: string
    sql: "hello" ;;
    link: {
      label: "testing out ._value"
      url: "https://google.com/{{ sale_price._value }}/dashboard/app_usage/app-usage/"
    }
  }

  dimension: testing_out_value {
    description: "ag_name.description"
    type: string
    sql: ${TABLE}.sale_price ;;
    link: {
      label: "testing out ._value"
      url: "https://google.com/{{ sale_price._value }}/dashboard/app_usage/app-usage/"
    }
  }

  dimension: if_statement_within_if_statement {
    description: "ag_name.description"
    type: string
    sql: ${TABLE}.sale_price ;;
    link: {
      label: "{% if id._value > 45 %} {{ value }} {% endif %}"
      url: "https://google.com/{% if sale_price._value == 6.95 %}6.95{% endif %}/dashboard/app_usage/app-usage/"
    }
  }

  measure: count_distinct {
    type: count_distinct
    sql: ${sale_price} ;;
  }

  measure: avg_minutes_per_viewing_subscriber_norm {
    type: average
    sql: ${TABLE}.sale_price/(${TABLE}.sale_price * 2.0);;
    label: "Average Minutes per Viewing Subscriber Norm"
    filters: {
      field: returned_date
      value: "13 weeks ago for 13 weeks"
    }
  }



  }
