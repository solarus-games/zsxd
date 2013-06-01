local map = ...
local game = map:get_game()

----------------------------------
-- FREAKING CAVE 2 OMFG         --
----------------------------------

function map:on_started(destination_point)

  -- No light inside the cave at start
  map:set_light(0)         
  -- Let the trap door opened
  map:set_doors_open("trap_door")
  -- Disable ennemies
  ennemy_1:set_enabled(false)
  ennemy_2:set_enabled(false)
end

function sensor_close_trap_door:on_activated()

  -- Closing trap door        
  map:close_doors("trap_door")
  sensor_close_trap_door:set_enabled(false)
end

-- Make appear some enemies
function make_appear_c1:on_activated()
  ennemy_1:set_enabled(true)
  make_appear_c1:set_enabled(false)
end

function make_appear_c2:on_activated()
  ennemy_2:set_enabled(true)
  make_appear_c2:set_enabled(false)        
end

function make_appear_c3:on_activated()
  make_appear_c3:set_enabled(false)
end

-- Teleporter at the end
function sensor_teleporter:on_activated()

  if not game:get_value("b56") then
    map:start_dialog("freaking_cave_teleporter")
    hero:start_jumping(6, 64, true)
  end
end

