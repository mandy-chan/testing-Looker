

include: "looker_project.model.lkml"

explore: order_items_2 {
  extends: [order_items]
  hidden: yes
  view_name: order_items

}
