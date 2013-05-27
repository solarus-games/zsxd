local map = ...

function fake_chest:on_empty()
  map:start_dialog("maison_boulet.fakechest")
  hero:unfreeze()
end

