local map = ...

----------------------------------
-- FREAKING CAVE 2 OMFG         --
----------------------------------

function map:on_map_started(destination_point)

  -- No light inside the cave at start
  sol.map.light_set(0)         
  -- Let the trap door openned
  sol.map.door_open("trap_door")
  -- Disable ennemies
  sol.map.enemy_set_enabled("ennemy_1", false)
  sol.map.enemy_set_enabled("ennemy_2", false)
end

function map:on_hero_on_sensor(sensor_name)

  -- Closing trap door        
  if sensor_name == "sensor_close_trap_door" then
    -- Close door
    sol.map.door_close("trap_door")
    sol.map.sensor_set_enabled("sensor_close_trap_door", false)

    -- Make appear some enemies
  elseif sensor_name == "make_appear_c1" then
    sol.map.enemy_set_enabled("ennemy_1", true)
    sol.map.sensor_set_enabled("make_appear_c1", false)
  elseif sensor_name == "make_appear_c2" then
    sol.map.enemy_set_enabled("ennemy_2", true)
    sol.map.sensor_set_enabled("make_appear_c2", false)        
  elseif sensor_name == "make_appear_c3" then
    sol.map.sensor_set_enabled("make_appear_c3", false)
    -- Teleporter at the end
  elseif sensor_name == "sensor_teleporter" then
    if not sol.game.savegame_get_boolean(56) then
      map:start_dialog("freaking_cave_teleporter")
      sol.map.hero_start_jumping(6, 64, true)
    end
  end
end
