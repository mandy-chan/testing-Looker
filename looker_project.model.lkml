connection: "thelook"

# include all the views
include: "*.view"
include: "*.dashboard"

datagroup: looker_project_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: looker_project_default_datagroup

explore: sql_runner_practice {}

explore: derived_table_test_w_parameter {}

explore: view_with_derived_table {}

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
}

explore: orders {
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: products_all_the_liquid {
  join: inventory_items {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products_all_the_liquid.id} ;;
    relationship: many_to_one
  }

}

explore: order_items_parameter {}

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
    user_attribute: company
    }
}

explore: users_nn {}

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

explore: renaming_view_20190508 {}

explore: zozo_table_20190509 {}

explore: zozo_table_null {}
