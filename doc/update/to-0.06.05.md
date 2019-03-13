change opt name for add panel action

```
@admin_panel.add_show_actions(@doctor, {}, index_action: {name: 'Врачи'})
->
@admin_panel.add_show_actions(@doctor, {}, with_index: {name: 'Врачи'})
```
