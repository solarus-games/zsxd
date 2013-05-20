local map = ...

-- Dungeon 1 1F SE (Temple of Stupidities)

local remove_water_delay = 500 -- delay between each step when some water is disappearing

function map:on_started(destionation_point_name)

  if game:get_value("b240") then
    -- the water is removed
    sol.map.tile_set_group_enabled("c_water", false)
    sol.map.tile_set_enabled("c_water_exit", true)
    sol.map.switch_set_activated("remove_water_switch", true)
  end
end

function map:on_map_opening_transition_finished(destination_point)

  -- show the welcome message
  if destination_point:get_name() == "from_outside" then
    map:start_dialog("dungeon_1.welcome")
  end
end

function map:on_door_open(door_name)

  if door_name == "weak_wall_red_tunic" then
    sol.audio.play_sound("secret")
  end
end

function map:on_switch_activated(switch_name)

  if switch_name == "remove_water_switch"
      and not game:get_value("b240") then
    sol.map.hero_freeze()
    remove_c_water()
  elseif switch_name == "ne_door_switch"
      and not sol.map.door_is_open("ne_door") then
    sol.map.camera_move(1072, 40, 250, open_ne_door)
  end
end

function open_ne_door()

  sol.audio.play_sound("secret")
  sol.map.door_open("ne_door")
end

function remove_c_water()

  sol.audio.play_sound("water_drain_begin")
  sol.audio.play_sound("water_drain")
  sol.map.tile_set_enabled("c_water_exit", true)
  sol.map.tile_set_enabled("c_water_source", false)
  sol.main.timer_start(remove_c_water_2, remove_water_delay)
end

function remove_c_water_2()

  sol.map.tile_set_enabled("c_water_middle", false)
  sol.main.timer_start(remove_c_water_3, remove_water_delay)
end

function remove_c_water_3()

  sol.map.tile_set_group_enabled("c_water_initial", false)
  sol.map.tile_set_group_enabled("c_water_less_a", true)
  sol.main.timer_start(remove_c_water_4, remove_water_delay)
end

function remove_c_water_4()

  sol.map.tile_set_group_enabled("c_water_less_a", false)
  sol.map.tile_set_group_enabled("c_water_less_b", true)
  sol.main.timer_start(remove_c_water_5, remove_water_delay)
end

function remove_c_water_5()

  sol.map.tile_set_group_enabled("c_water_less_b", false)
  sol.map.tile_set_group_enabled("c_water_less_c", true)
  sol.main.timer_start(remove_c_water_6, remove_water_delay)
end

function remove_c_water_6()

  sol.map.tile_set_group_enabled("c_water_less_c", false)
  game:set_value("b240", true)
  sol.audio.play_sound("secret")
  sol.map.hero_unfreeze()
end



