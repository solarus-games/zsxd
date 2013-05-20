local map = ...

function map:on_chest_empty(chest_name)

  sol.map.dialog_start("maison_boulet.fakechest")
  sol.map.hero_unfreeze()
end
