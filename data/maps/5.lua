local map = ...
local game = map:get_game()

function fake_chest:on_opened()
  game:start_dialog("maison_boulet.fakechest")
  hero:unfreeze()
end

