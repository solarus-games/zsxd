local map = ...
local game = map:get_game()

-- Dungeon 1 1F SE (Temple of Stupidities)

local remove_water_delay = 500 -- delay between each step when some water is disappearing
local remove_c_water
local remove_c_water_2
local remove_c_water_3
local remove_c_water_4
local remove_c_water_5
local remove_c_water_6

function map:on_started(destionation_point_name)

  if game:get_value("b240") then
    -- the water is removed
    map:set_entities_enabled("c_water", false)
    c_water_exit:set_enabled(true)
    remove_water_switch:set_activated(true)
  end
end

function map:on_opening_transition_finished(destination_point)

  -- show the welcome message
  if destination_point ~= nil
      and destination_point:get_name() == "from_outside" then
    game:start_dialog("dungeon_1.welcome")
  end
end

function weak_wall_red_tunic:on_opened()
  sol.audio.play_sound("secret")
end

function remove_water_switch:on_activated()

  if not game:get_value("b240") then
    hero:freeze()
    remove_c_water()
  end
end

function ne_door_switch:on_activated()

  if ne_door:is_closed() then
    map:move_camera(1072, 40, 250, function()
      sol.audio.play_sound("secret")
      map:open_doors("ne_door")
    end)
  end
end

function remove_c_water()

  sol.audio.play_sound("water_drain_begin")
  sol.audio.play_sound("water_drain")
  c_water_exit:set_enabled(true)
  c_water_source:set_enabled(false)
  sol.timer.start(map, remove_water_delay, remove_c_water_2)
end

function remove_c_water_2()

  c_water_middle:set_enabled(false)
  sol.timer.start(map, remove_water_delay, remove_c_water_3)
end

function remove_c_water_3()

  map:set_entities_enabled("c_water_initial", false)
  map:set_entities_enabled("c_water_less_a", true)
  sol.timer.start(map, remove_water_delay, remove_c_water_4)
end

function remove_c_water_4()

  map:set_entities_enabled("c_water_less_a", false)
  map:set_entities_enabled("c_water_less_b", true)
  sol.timer.start(map, remove_water_delay, remove_c_water_5)
end

function remove_c_water_5()

  map:set_entities_enabled("c_water_less_b", false)
  map:set_entities_enabled("c_water_less_c", true)
  sol.timer.start(map, remove_water_delay, remove_c_water_6)
end

function remove_c_water_6()

  map:set_entities_enabled("c_water_less_c", false)
  game:set_value("b240", true)
  sol.audio.play_sound("secret")
  hero:unfreeze()
end

