local map = ...
local game = map:get_game()

-- Temple of Stupidities 1F NE

local will_remove_water = false

function map:on_started(destination_point)

  -- switches of stairs of the central room
  for i = 1, 7 do
    if not game:get_value("b" .. (292 + i)) then
      map:get_entity("stairs_" .. i):set_enabled(false)
      map:get_entity("stairs_".. i .. "_switch"):set_activated(false)
    else
      map:get_entity("stairs_".. i .. "_switch"):set_activated(true)
    end
  end

  -- room with enemies to fight
  if game:get_value("b301") then
    map:remove_entities("fight_room_enemy")
  end

  -- block pushed to remove the water of 2F SW
  if game:get_value("b283") then
    remove_water_block:set_enabled(false)
  else
    fake_remove_water_block:set_enabled(false)
  end

  -- boss
  map:set_doors_open("boss_door", true)
  if game:get_value("b306") then
    boss_gate:set_enabled(true)
  end
end

local function stairs_switch_activated(switch)

  local i = tonumber(switch:get_name():match("^stairs_([1-7])_switch$"))
  if i == nil then
    error("Wrong stairs switch: " .. switch:get_name())
  end

  map:get_entity("stairs_" .. i):set_enabled(true)
  sol.audio.play_sound("secret")
  game:set_value("b" .. (292 + i), true)
end
for i = 1, 7 do
  map:get_entity("stairs_" .. i .. "_switch").on_activated = stairs_switch_activated
end

local function switch_activated_on(switch)

  local i = tonumber(switch:get_name():match("switch_torch_([0-9]*)_on"))
  map:set_entities_enabled("torch_" .. i, true)
  map:get_entity("switch_torch_" .. i .. "_off"):set_activated(false)

  if i == 7 then
    -- This one has two off switches.
    switch_torch_7_off_2:set_activated(false)
  end
end

local function switch_activated_off(switch)

  local i = tonumber(switch:get_name():match("switch_torch_([0-9]*)_off"))
  map:set_entities_enabled("torch_" .. i, false)
  map:get_entity("switch_torch_" .. i .. "_on"):set_activated(false)
end
for i = 1, 11 do
  map:get_entity("switch_torch_" .. i .. "_on").on_activated = switch_activated_on
  map:get_entity("switch_torch_" .. i .. "_off").on_activated = switch_activated_off
end
switch_torch_7_off_2.on_activated = switch_activated_off

local function fight_room_enemy_dead(enemy)

  if not map:has_entities("fight_room_enemy")
      and fight_room_door:is_closed() then
    sol.audio.play_sound("secret")
    map:open_doors("fight_room_door")
  end
end
for enemy in map:get_entities("fight_room_enemy") do
  enemy.on_dead = fight_room_enemy_dead
end

if boss ~= nil then
  function boss:on_dead()
    map:set_entities_enabled("boss_gate", true) 
    game:set_value("b62", true)  -- Open the door of Link's cave.
    sol.audio.play_sound("secret")
  end
end

function remove_water_sensor:on_activated()

  if not game:get_value("b283")
      and not will_remove_water then
    sol.timer.start(map, 500, function()
      sol.audio.play_sound("water_drain_begin")
      sol.audio.play_sound("water_drain")
      game:start_dialog("dungeon_1.2f_sw_water_removed")
      game:set_value("b283", true)
    end)
    will_remove_water = true
  end
end

function start_boss_sensor:on_activated()

  if boss_door:is_open()
      and not game:get_value("b306") then
    map:close_doors("boss_door")
    hero:freeze()
    sol.timer.start(map, 1000, function()
      boss:set_enabled(true)
      sol.audio.play_music("ganon_theme")
      hero:unfreeze()
      sol.timer.start(map, 1000, function()
        game:start_dialog("dungeon_1.ganon", function()
          sol.audio.play_music("ganon_battle")
        end)
      end)
    end)
  end
end

function boss_hint_stone:on_interaction()

  sol.audio.play_music("victory")
  hero:set_direction(3)
  hero:freeze()
  sol.timer.start(map, 9000, function()
    game:start_dialog("dungeon_1.boss_hint_stone", game:get_player_name(), function()
      sol.timer.start(map, 1000, function()
        hero:start_victory(function()
          sol.audio.play_sound("warp")
          hero:teleport("4", "from_temple_of_stupidities")
        end)
      end)
    end)
  end)
end

