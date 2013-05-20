local map = ...

-- Temple of Stupidities 1F NE

local will_remove_water = false

function map:on_started(destination_point)

  -- switches of stairs of the central room
  for i = 1, 7 do
    if not game:get_value("b292" + i) then
      sol.map.stairs_set_enabled("stairs_" .. i, false)
      sol.map.switch_set_activated("stairs_".. i .. "_switch", false)
    else
      sol.map.switch_set_activated("stairs_" .. i .. "_switch", true)
    end
  end

  -- room with enemies to fight
  if game:get_value("b301") then
    sol.map.enemy_remove_group("fight_room")
  end

  -- block pushed to remove the water of 2F SW
  if game:get_value("b283") then
    sol.map.block_set_enabled("remove_water_block", false)
  else
    sol.map.block_set_enabled("fake_remove_water_block", false)
  end

  -- boss
  sol.map.door_set_open("boss_door", true)
  if game:get_value("b306") then
    sol.map.tile_set_enabled("boss_gate", true)
  end
end

function map:on_switch_activated(switch_name)

  local i = string.match(switch_name, "^stairs_([1-7])_switch$")
  if (i ~= nil) then
    sol.map.stairs_set_enabled("stairs_" .. i, true)
    sol.audio.play_sound("secret")
    game:set_value("b292" + i, true)
  elseif switch_name == "switch_torch_1_on" then
    sol.map.tile_set_enabled("torch_1", true)
    sol.map.switch_set_activated("switch_torch_1_off", false)
  elseif switch_name == "switch_torch_1_off" then
    sol.map.tile_set_enabled("torch_1", false)
    sol.map.switch_set_activated("switch_torch_1_on", false)
  elseif switch_name == "switch_torch_2_on" then
    sol.map.tile_set_enabled("torch_2", true)
    sol.map.switch_set_activated("switch_torch_2_off", false)
  elseif switch_name == "switch_torch_2_off" then
    sol.map.tile_set_enabled("torch_2", false)
    sol.map.switch_set_activated("switch_torch_2_on", false)
  elseif switch_name == "switch_torch_3_on" then
    sol.map.tile_set_enabled("torch_3", true)
    sol.map.switch_set_activated("switch_torch_3_off", false)
  elseif switch_name == "switch_torch_3_off" then
    sol.map.tile_set_enabled("torch_3", false)
    sol.map.switch_set_activated("switch_torch_3_on", false)
  elseif switch_name == "switch_torch_4_on" then
    sol.map.tile_set_enabled("torch_4", true)
    sol.map.switch_set_activated("switch_torch_4_off", false)
  elseif switch_name == "switch_torch_4_off" then
    sol.map.tile_set_enabled("torch_4", false)
    sol.map.switch_set_activated("switch_torch_4_on", false)
  elseif switch_name == "switch_torch_5_on" then
    sol.map.tile_set_enabled("torch_5", true)
    sol.map.switch_set_activated("switch_torch_5_off", false)
  elseif switch_name == "switch_torch_5_off" then
    sol.map.tile_set_enabled("torch_5", false)
    sol.map.switch_set_activated("switch_torch_5_on", false)
  elseif switch_name == "switch_torch_6_on" then
    sol.map.tile_set_enabled("torch_6", true)
    sol.map.switch_set_activated("switch_torch_6_off", false)
  elseif switch_name == "switch_torch_6_off" then
    sol.map.tile_set_enabled("torch_6", false)
    sol.map.switch_set_activated("switch_torch_6_on", false)
  elseif switch_name == "switch_torch_7_on" then
    sol.map.tile_set_enabled("torch_7", true)
    sol.map.switch_set_activated("switch_torch_7_off", false)
    sol.map.switch_set_activated("switch_torch_7_off_2", false)
  elseif switch_name == "switch_torch_7_off"
      or switch_name == "switch_torch_7_off_2" then
    sol.map.tile_set_enabled("torch_7", false)
    sol.map.switch_set_activated("switch_torch_7_on", false)
  elseif switch_name == "switch_torch_8_on" then
    sol.map.tile_set_enabled("torch_8", true)
    sol.map.switch_set_activated("switch_torch_8_off", false)
  elseif switch_name == "switch_torch_8_off" then
    sol.map.tile_set_enabled("torch_8", false)
    sol.map.switch_set_activated("switch_torch_8_on", false)
  elseif switch_name == "switch_torch_9_on" then
    sol.map.tile_set_enabled("torch_9", true)
    sol.map.switch_set_activated("switch_torch_9_off", false)
  elseif switch_name == "switch_torch_9_off" then
    sol.map.tile_set_enabled("torch_9", false)
    sol.map.switch_set_activated("switch_torch_9_on", false)
  elseif switch_name == "switch_torch_10_on" then
    sol.map.tile_set_enabled("torch_10", true)
    sol.map.switch_set_activated("switch_torch_10_off", false)
  elseif switch_name == "switch_torch_10_off" then
    sol.map.tile_set_enabled("torch_10", false)
    sol.map.switch_set_activated("switch_torch_10_on", false)
  elseif switch_name == "switch_torch_11_on" then
    sol.map.tile_set_enabled("torch_11", true)
    sol.map.switch_set_activated("switch_torch_11_off", false)
  elseif switch_name == "switch_torch_11_off" then
    sol.map.tile_set_enabled("torch_11", false)
    sol.map.switch_set_activated("switch_torch_11_on", false)
  end
end

function map:on_enemy_dead(enemy_name)

  if string.find(enemy_name, '^fight_room')
      and sol.map.enemy_is_group_dead("fight_room") then

    sol.audio.play_sound("secret")
    sol.map.door_open("fight_room_door")
  elseif enemy_name == "boss" then
    sol.map.tile_set_enabled("boss_gate", true) 
    game:set_value("b62", true) -- open the door of Link's cave
    sol.audio.play_sound("secret")
  end
end

function map:on_hero_on_sensor(sensor_name)

  if sensor_name == "remove_water_sensor"
      and not game:get_value("b283")
      and not will_remove_water then

    sol.main.timer_start(remove_2f_sw_water, 500)
    will_remove_water = true
  elseif sensor_name == "start_boss_sensor" then
    if sol.map.door_is_open("boss_door")
        and not game:get_value("b306") then
      sol.map.door_close("boss_door")
      sol.map.hero_freeze()
      sol.main.timer_start(start_boss, 1000)
    end
  end
end

function remove_2f_sw_water()

  sol.audio.play_sound("water_drain_begin")
  sol.audio.play_sound("water_drain")
  map:start_dialog("dungeon_1.2f_sw_water_removed")
  game:set_value("b283", true)
end

function start_boss()

  sol.map.enemy_set_enabled("boss", true)
  sol.audio.play_music("ganon_theme")
  sol.main.timer_start(ganon_dialog, 1000)
  sol.map.hero_unfreeze()
end

function ganon_dialog()

  map:start_dialog("dungeon_1.ganon")
end

function map:on_npc_interaction(npc_name)

  if npc_name == "boss_hint_stone" then
    sol.main.timer_start(another_castle, 9000)
    sol.audio.play_music("victory")
    sol.map.hero_set_direction(3)
    sol.map.hero_freeze()
  end
end

function another_castle()

  map:start_dialog("dungeon_1.boss_hint_stone")
  sol.map.dialog_set_variable("dungeon_1.boss_hint_stone",
    sol.game.savegame_get_name())
end

function map:on_dialog_finished(dialog_id)

  if dialog_id == "dungeon_1.boss_hint_stone" then
    sol.main.timer_start(victory, 1000)
  elseif dialog_id == "dungeon_1.ganon" then
    sol.audio.play_music("ganon_battle")
  end
end

function victory()

  sol.map.hero_start_victory_sequence()
  sol.main.timer_start(leave_dungeon, 2000)
end

function leave_dungeon()

  sol.audio.play_sound("warp")
  sol.map.hero_set_map(4, "from_temple_of_stupidities", 1)
end

