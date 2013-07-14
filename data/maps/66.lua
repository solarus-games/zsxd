local map = ...
local game = map:get_game()

-- Temple of Stupidities 2F SW

function map:on_started(destination_point)

  -- water removed
  if game:get_value("b283") then
    map:set_entities_enabled("water", false)
  end

  -- fight room
  map:set_doors_open("fight_door", true)
  if game:get_value("b244") then
    map:remove_entities("fight_enemy")
  else
    map:set_entities_enabled("fight_enemy", false)
    fight_chest:set_enabled(false)
  end
end

function fight_sensor:on_activated()

  if not game:get_value("b244")
      and fight_door:is_open()
      and not fight_chest:is_enabled() then
    map:close_doors("fight_door")
    map:set_entities_enabled("fight_enemy", true)
  end
end

local function fight_enemy_dead(enemy)

  if not map:has_entities("fight_enemy") then
    sol.audio.play_sound("chest_appears")
    fight_chest:set_enabled(true)
    map:open_doors("fight_door")
  end
end
for enemy in map:get_entities("fight_enemy") do
  enemy.on_dead = fight_enemy_dead
end

