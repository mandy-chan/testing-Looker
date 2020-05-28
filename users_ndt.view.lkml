# If necessary, uncomment the line below to include explore_source.
# include: "looker_project.model.lkml"

include: "order_items.explore.lkml"

view: users_ndt {
  derived_table: {
    explore_source: order_items {
      column: gender { field: users.gender }
      column: count { field: users.count }
    }
  }
  dimension: gender {}
  dimension: count {
    type: number
  }
}
