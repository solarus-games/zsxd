local map = ...

-- Temple of Stupidities 2F SE

function map:on_map_started(destination_point)

  -- water removed
  if sol.game.savegame_get_boolean(283) then
    sol.map.tile_set_group_enabled("water", false)
  end
end

