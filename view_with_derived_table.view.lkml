include: "derived_table_w_parameter.view"

view: view_with_derived_table {
  extends: [derived_table_test_w_parameter]
#     derived_table: {
#       sql:
#           SELECT
#               users.city  AS `users.city`,
#               COUNT(DISTINCT users.id ) AS `users.count`
#             FROM demo_db.order_items  AS order_items
#             LEFT JOIN demo_db.orders  AS orders ON order_items.id = orders.id
#             LEFT JOIN demo_db.users  AS users ON orders.user_id = users.id
#             WHERE {% parameter derived_table_w_parameter.city_filter %} = users.city
#             GROUP BY 1
#             ORDER BY COUNT(DISTINCT users.id ) DESC
#             LIMIT 500
#              ;;
#     }
#
#     parameter: city_filter {
#       type: string
#     }
#
#     measure: count {
#       type: count
#       drill_fields: [detail*]
#     }
#
#     dimension: users_city {
#       type: string
#       sql: ${TABLE}.`users.city` ;;
#     }
#
#     dimension: users_count {
#       type: number
#       sql: ${TABLE}.`users.count` ;;
#     }
#
#     set: detail {
#       fields: [users_city, users_count]
#     }
#
}
