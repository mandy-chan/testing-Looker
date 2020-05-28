# If necessary, uncomment the line below to include explore_source.
# include: "looker_project.model.lkml"

view: new_ndt {
  derived_table: {
    explore_source: order_items_parameter {
      column: batch_categories_dynamic_same_store {}
      column: id {}
      bind_filters: {
        from_field: new_ndt.testing_filter
        to_field: order_items_parameter.batch_categories_dynamic_same_store
      }
    }
  }
  dimension: batch_categories_dynamic_same_store {}

  dimension: id {}

  parameter: testing_filter {
    allowed_value: {
      label: "Week"
      value: "Week"
    }
    allowed_value: {
      label: "Day"
      value: "Day"
    }
  }
}
