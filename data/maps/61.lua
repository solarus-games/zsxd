local map = ...
local game = map:get_game()

-- Temple of Stupidities 1F NE

local cannonballs_enabled = false
local nb_cannonballs_created = 0
local remove_water_delay = 500 -- delay between each step when some water is disappearing
local fighting_miniboss = false
local remove_c_water
local remove_c_water_2
local remove_c_water_3
local remove_c_water_4
local remove_c_water_5
local remove_c_water_6

-- initialization
function map:on_started(destination_point)

  -- miniboss door
  self:set_doors_open("miniboss_door", true)

  -- water drained
  if game:get_value("b303") then
    self:set_entities_enabled("c_water", false)
    c_water_exit:set_enabled(true)
    remove_water_switch:set_activated(true)
  end

  -- WTF room
  map:set_doors_open("wtf_door", true)
end

-- weak walls: play the secret sound
function weak_wall_compass:on_opened()
  sol.audio.play_sound("secret")
end

function weak_wall_red_tunic:on_opened()
  sol.audio.play_sound("secret")
end

-- dialog near the WTF room
function map:on_obtained_treasure(item, variant, savegame_variable)

  if savegame_variable == "b248" then
    map:start_dialog("dungeon_1.small_key_danger_east")
  end
end

-- random cannonballs
local function launch_cannonball()

  nb_cannonballs_created = nb_cannonballs_created + 1
  map:create_enemy{
    name = "cannonball_" .. nb_cannonballs_created,
    breed = "cannonball",
    x = 280,
    y = 725,
    layer = 0,
    direction = 3,
  }
  sol.timer.start(map, 1500, launch_cannonball)
end

-- miniboss
local function cannonballs_start_sensor_activated(sensor)

  if not cannonballs_enabled then
    launch_cannonball()
    cannonballs_enabled = true
  end
end
for sensor in map:get_entities("cannonballs_start_sensor") do
  sensor.on_activated = cannonballs_start_sensor_activated
end

local function cannonballs_stop_sensor_activated(sensor)
  sol.timer.stop_all(map)
  cannonballs_enabled = false
end
for sensor in map:get_entities("cannonballs_stop_sensor") do
  sensor.on_activated = cannonballs_stop_sensor_activated
end

function start_miniboss_sensor:on_activated()

  if not game:get_value("b302")
      and not fighting_miniboss then
    -- the miniboss is alive
    map:close_doors("miniboss_door")
    hero:freeze()
    fighting_miniboss = true
    sol.timer.start(map, 1000, function()
      sol.audio.play_music("boss")
      miniboss:set_enabled(true)
      hero:unfreeze()
    end)
  end
end

local function wtf_sensor_activated(sensor)

  if wtf_door:is_open()
      and map:has_entities("wtf_room_enemy") then
    map:close_doors("wtf_door")
  end
end
for sensor in map:get_entities("wtf_sensor") do
  sensor.on_activated = wtf_sensor_activated
end

if miniboss ~= nil then
  function miniboss:on_dead()

    sol.audio.play_music("dark_world_dungeon")
    map:open_doors("miniboss_door")
  end
end

local function wtf_room_enemy_dead(enemy)

  if not map:has_entities("wtf_room_enemy")
      and wtf_door:is_closed() then
    map:open_doors("wtf_door")
    sol.audio.play_sound("secret")
  end
end
for enemy in map:get_entities("wtf_room_enemy") do
  enemy.on_dead = wtf_room_enemy_dead
end

-- draining the water
function remove_water_switch:on_activated()

  if not game:get_value("b303") then
    hero:freeze()
    remove_c_water()
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

  c_water_initial:set_enabled(false)
  c_water_less_a:set_enabled(true)
  sol.timer.start(map, remove_water_delay, remove_c_water_4)
end

function remove_c_water_4()

  c_water_less_a:set_enabled(false)
  c_water_less_b:set_enabled(true)
  sol.timer.start(map, remove_water_delay, remove_c_water_5)
end

function remove_c_water_5()

  c_water_less_b:set_enabled(false)
  c_water_less_c:set_enabled(true)
  sol.timer.start(map, remove_water_delay, remove_c_water_6)
end

function remove_c_water_6()

  c_water_less_c:set_enabled(false)
  game:set_value("b303", true)
  sol.audio.play_sound("secret")
  hero:unfreeze()
end

