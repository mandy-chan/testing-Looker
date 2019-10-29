- dashboard: old_lookml
  title: Old Lookml
  layout: tile
  tile_size: 100

  filters:

  elements:
    - name: Gudetama
      title_text: <img src="https://cms.qz.com/wp-content/uploads/2016/08/gu_announcement_01.png?w=410&h=230.88125&strip=all&quality=75"/>
      type: text
    - title: derived_table_10k
      name: derived_table_10k
      model: looker_project
      explore: derived_table_10k
      type: looker_table
      fields: [derived_table_10k.x]
      limit: 10000
      series_types: {}
      row: 0
      col: 0
      width: 8
      height: 6
