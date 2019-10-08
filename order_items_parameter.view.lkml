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
    sql: ${TABLE}.returned_at ;;
  }


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

  parameter: end_user_date {
    type: date
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





  #   CASE WHEN
  #   EXTRACT(MONTH FROM ${returned_raw}) = EXTRACT(MONTH FROM {% parameter s_mtd %}) and
  #   EXTRACT(DAY FROM {% parameter s_mtd %}) = 1 THEN
  #   DATE_SUB(${returned_raw}, INTERVAL 1 MONTH)
  #   ELSE ${returned_raw}
  #   END ;;
  # }

#   dimension: settlement_is_mtd {
#     type: yesno
#     sql:
#       ;;
#   }

  # month = month of parameter
  # day of parameter != 1, return data from current month
  # else return data from last month

  # < EXTRACT(MONTH FROM {% parameter s_mtd %})


  dimension: filter_at_date {
    sql:
    {% if date_type._parameter_value == "'day'" %}
    ${returned_date}
    {% elsif date_type._parameter_value == 'month' %}
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
    sql: ${TABLE}.sale_price ;;
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





  }
