# If necessary, uncomment the line below to include explore_source.
# include: "looker_project.model.lkml"

view: order_items_ndt {
  derived_table: {
    explore_source: order_items {
      column: count { }
    }
  }

  dimension: count {
    type: number
  }
}
