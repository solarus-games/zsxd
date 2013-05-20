local map = ...

function map:on_chest_empty(chest_name)

  map:start_dialog("maison_boulet.fakechest")
  sol.map.hero_unfreeze()
end
