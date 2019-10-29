connection: "thelook"
#
# include all the views
include: "*.view"
include: "*.dashboard"
include: "extends_for_explores.explore.lkml"

datagroup: looker_project_default_datagroup {
  max_cache_age: "4 hour"
  sql_trigger: SELECT FLOOR(UNIX_TIMESTAMP() / (0.83*60*60))  ;;
}

persist_with: looker_project_default_datagroup

access_grant: access_grants_1 {
  allowed_values: ["white"]
  user_attribute: color
}

explore: derived_table_10k {
  persist_with: looker_project_default_datagroup
}

explore: extension_hidden {
  extension: required
  view_name: any_name_that_i_want
  join: products {
    sql_on: ${products.id} = ${any_name_that_i_want.id} ;;
    type: left_outer
    relationship: one_to_one
  }
}

explore: order_items_3 {
  extends: [extension_hidden]
  from: orders
  join: users {
    sql_on: ${users.id} = ${any_name_that_i_want.id} ;;
    relationship: one_to_one
  }

}

explore: users_datestart_dateend {}

explore: order_items_with_dt {
  from: order_items
  join: derived_table {
    type: left_outer
    sql_on: ${order_items_with_dt.id} = ${derived_table.id} ;;
    relationship: one_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${products.id} = ${order_items_with_dt.id} ;;
    relationship: many_to_many
  }

}
explore: derived_table {
  persist_with: looker_project_default_datagroup
}

explore: always_filter_workaround {}

explore: sql_runner_practice {}

explore: derived_table_test_w_parameter {}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  join: orders {
    type: left_outer
    sql_on: ${order_items.id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: test_derived_user_cohort {
    view_label: "XX - User Cohort Filters"
    type: inner
    relationship: many_to_one
    sql_on: ${users.id} = ${test_derived_user_cohort.user_id} ;;
  }

  join: users_ndt {
    relationship: one_to_one
    type: left_outer
    sql_on: 1=1 ;;
  }
}

explore: orders {
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

}

explore: users_cohort {
  from: users
  join: test_derived_user_cohort {
    view_label: "XX - User Cohort Filters"
    type: inner
    relationship: many_to_one
    sql_on: ${users_cohort.id} = ${test_derived_user_cohort.user_id} ;;
  }
}

explore: products_all_the_liquid {
  join: inventory_items {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products_all_the_liquid.id} ;;
    relationship: many_to_one
  }

}

explore: order_items_parameter {
  sql_always_where:
  {% if order_items_parameter.date_filter._is_filtered %}
--  ${order_items_parameter.returned_month}
  {% condition order_items_parameter.date_filter %} ${order_items_parameter.returned_date} {% endcondition %}
  {% else %}
  ${order_items_parameter.returned_date} = (SELECT max(returned_at) FROM demo_db.order_items)
  {% endif %}
  ;;
}

explore: dt_with_templated_filters {}

explore: user_data {
  join: users {
    type: left_outer
    sql_on: ${user_data.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: users_with_access_filter {
  view_name: users
  access_filter: {
    field: users.city
    user_attribute: city
    }
}

explore: users_with_access_grants {
  view_name: users
  required_access_grants: [access_grants_1]
}

explore: users_with_sql_always_filter {
  sql_always_where: ${first_name} LIKE "%Man%" ;;
}

explore: zozo_table_20190507 {
  fields: [ALL_FIELDS*, -zozo_table_20190507.users_count]
  view_label: "Testing View Label"
  always_filter: {
    filters: {
      field: users_first_name
      value: "M%"
    }
  }
}

map_layer: chapter_01 {
  feature_key: "2019_SVNJB_Chapter_Boundaries"
  property_key: "Berrryessa/Milpitas NJB"
  format: topojson
  file: "2019_SVNJB_Chapter_Boundaries.topojson"
}

# explore: renaming_view_20190508 {}
