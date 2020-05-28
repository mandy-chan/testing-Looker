#dashboard 22

include: "inventory_items.lkml"

view: products_filter_dont_touch {
  sql_table_name: demo_db.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    link: {
      label: "Drill To Dashboard 23"
      url: "/dashboards/23?Brand={{ brand._value | url_encode }}"
    }
  }

  dimension: brand_2 {
    type: string
    sql: ${TABLE}.brand ;;
    link: {
      label: "Drill To Dashboard 23"
      url: "/dashboards/23?Brand={{ _filters['products_filter_dont_touch.brand_2'] | url_encode }}&Date={{ _filters['products_filter_dont_touch.created_3_date'] | url_encode }}"
    }
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    link: {
      label: "Drills To Look 16 carrying filter value"
      url: "/looks/16?&f[products_filter_dont_touch.category]={{ value }}"
    }
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
    link: {
      label: "&f acts as the name of the filter so this filter won't work"
      url: "/dashboards/23?&f[products_filter_dont_touch.department]={{ value }}"
    }
  }

  dimension: created_3_date {
    type: date
    sql: ${inventory_items.created_date} ;;
  }

  dimension: department_2 {
    type: string
    sql: ${TABLE}.department ;;
    link: {
      label: "Value of Department in Dashboard 23 will equal to filter value of ID"
      url: "/dashboards/23?&Department={{ _filters['products_filter_dont_touch.id'] | url_encode }}"
    }
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
    link: {
      label: "Rank value of Look 16 becomes value of ID"
      url: "/looks/16?&f[products_filter_dont_touch.rank]={{ _filters['products_filter_dont_touch.id'] | url_encode }}"
    }
  }


  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    link: {
      label: "testing"
      url: "/looks/18?&f[orders.created_date]=&f[products.sku]=&f[order_items.sku]"
    }

  }

  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
  }

}
