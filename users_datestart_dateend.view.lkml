view: users_datestart_dateend {
  sql_table_name: demo_db.users ;;
  # {% if testdb._parameter_value == 'demo_db.users' %}
  #   demo_db.users
  # {% elsif testdb._parameter_value == 'demo_db.orders' %}
  #   demo_db.orders
  # {% elsif testdb._is_filtered %}
  #   1=1
  # {% else %}
  #   "chili"
  # {% endif %} ;;

  parameter: testdb {
    type: unquoted
    allowed_value: { label: "users" value: "demo_db.users" }
    allowed_value: { label: "orders" value: "demo_db.orders" }
    allowed_value: { label: "products" value: "demo_db.products" }
  }

  filter: enddate_match_filter {
    type: date
  }


  dimension: enddate_match {
    type: yesno
    sql:  ${created_date} = {% date_end created_date %}  ;;
  }

  parameter: testparam_1 {
    type: date
  }

  parameter: testparam_2 {
    type: date
  }

  dimension: date_to_check {
    type: date
    sql: ${TABLE}.created_at ;;
  }

  dimension: monthly {
    type: yesno
    sql: month(${date_to_check}) = month( {% parameter testparam_1 %} ) AND year(${date_to_check}) = year( {% parameter testparam_1 %} )
      ;;
  }

  dimension: fiscal {
    type: yesno
    sql: DATE('2019-01-01') <= ${date_to_check} AND month(${date_to_check}) <= month({% parameter testparam_2 %}) AND year(${date_to_check}) = year( {% parameter testparam_2 %} );;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension_group: created {
    type: time
    timeframes: []
    sql: ${TABLE}.created_at ;;
  }

  filter: 12_months {
    type: date
    sql: ${created_date} > {% date_start date_filter %} AND ${created_date} < DATE_ADD({% date_end date_filter %}, INTERVAL 12 MONTH) ;;
  }


  filter: date_filter {
    type: date
    sql: ${created_date} > {% date_start date_filter %} AND ${created_date} < DATE_ADD({% date_end date_filter %}, INTERVAL 1 MONTH);;
  }

# https://discourse.looker.com/t/dynamic-date-filter-comparisons/5471

  filter: period_date_filter {
    description: "Use this date filter in combination with the timeframes dimension for dynamic date filtering"
    type: date
  }

  dimension_group: filter_start_date {
    type: time
    timeframes: [raw]
    sql: CASE WHEN {% date_start period_date_filter  %} IS NULL THEN '1970-01-01' ELSE NULLIF({% date_start period_date_filter  %}, 0)::timestamp END;;
# MySQL: CASE WHEN {% date_start date_filter %} IS NULL THEN '1970-01-01' ELSE  TIMESTAMP(NULLIF({% date_start date_filter %}, 0)) END;;
  }

  dimension_group: filter_end_date {
    type: time
    timeframes: [raw]
    sql: CASE WHEN {% date_end period_date_filter %} IS NULL THEN CURRENT_DATE ELSE NULLIF({% date_end period_date_filter %}, 0)::timestamp END;;
# MySQL: CASE WHEN {% date_end date_filter %} IS NULL THEN NOW() ELSE TIMESTAMP(NULLIF({% date_end date_filter %}, 0)) END;;
  }

  dimension: interval {
    type: number
    sql: TIMESTAMPDIFF(second, ${filter_end_date_raw}, ${filter_start_date_raw});;
  }

  dimension: previous_start_date {
    type: date
    sql:DATE_ADD(${filter_start_date_raw}, interval ${interval} second) ;;
  }

  dimension: period_timeframes {
    suggestions: ["period","previous period"]
    type: string
    case:  {
      when:  {
        sql: ${created_date} BETWEEN ${filter_start_date_raw} AND  ${filter_end_date_raw};;
        label: "Period"
      }
      when: {
        sql: ${created_date} BETWEEN ${previous_start_date} AND ${filter_start_date_raw} ;;
        label: "Previous Period"
      }
      else: "Not in time period"
    }
  }

  filter: date_filter_name {
    type: date
  }

  dimension: datestart_dateend {
    type: yesno
    sql: DATE_ADD({% date_start date_filter_name %}, INTERVAL -35 week) < ${created_date} AND ${created_date} < DATE_ADD({% date_end date_filter_name %}, INTERVAL -6 week)  ;;
  }

# https://discourse.looker.com/t/analytic-block-dynamic-previous-period-analysis-using-date-start-date-end/5361

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  measure: count {
    type: count
  }

}
