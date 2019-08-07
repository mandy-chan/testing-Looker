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
    type: unquoted
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

  dimension: filter_at_date {
    sql:
    {% if date_type._parameter_value == 'day' %}
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

  }
