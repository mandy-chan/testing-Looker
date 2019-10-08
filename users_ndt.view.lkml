# If necessary, uncomment the line below to include explore_source.
# include: "looker_project.model.lkml"

include: "extends_for_explores.explore.lkml"

view: users_ndt {
  derived_table: {
    explore_source: order_items {
      column: created_month { field: users.created_month }
      column: count { field: users.count }
      column: gender { field: users.gender }
      bind_filters: {
        to_field: products.category
        from_field: products.category
      }

      bind_filters: {
        to_field: users.city
        from_field: users.country
      }
    }
  }
  dimension: created_month {
    type: date_month
  }
  dimension: count {
    type: number
  }
  dimension: gender {}
}
