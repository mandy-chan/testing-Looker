view: derived_table_10k {
  derived_table: {
    sql:  select (th*1000+h*100+t*10+u+1) x from
(select 0 th union select 1 union select 2 union select 3 union select 4 union
select 5 union select 6 union select 7 union select 8 union select 9) A,
(select 0 h union select 1 union select 2 union select 3 union select 4 union
select 5 union select 6 union select 7 union select 8 union select 9) B,
(select 0 t union select 1 union select 2 union select 3 union select 4 union
select 5 union select 6 union select 7 union select 8 union select 9) C,
(select 0 u union select 1 union select 2 union select 3 union select 4 union
select 5 union select 6 union select 7 union select 8 union select 9) D
order by x;;

  }

  dimension: x {
    sql: ${TABLE}.x ;;
    type: number
  }

}
