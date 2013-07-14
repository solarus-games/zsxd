local map = ...

-- Temple of Stupidities 1F NW

-- stupid run between switches and doors
local timer_callback = nil
local timer_delay = 0
local door_a_passed = false
local door_b_passed = false
local door_c_passed = false
local close_door_a
local close_door_b
local close_door_c

-- when pressing a switch, move the camera and open a door
function stupid_run_switch_a:on_activated()
  map:move_camera(1272, 152, 250, function()
    map:open_doors("stupid_run_door_a")
    timer_callback = close_door_a
    timer_delay = 7000
  end)
end

function stupid_run_switch_b:on_activated()
  map:move_camera(1288, 296, 250, function()
    map:open_doors("stupid_run_door_b")
    timer_callback = close_door_b
    timer_delay = 3500
  end)
end

function stupid_run_switch_c:on_activated()
  map:move_camera(1456, 320, 250, function()
    map:open_doors("stupid_run_door_c")
    timer_callback = close_door_c
    timer_delay = 4000
  end)
end

function map:on_camera_back()
  -- start the door timer once the camera is back
  local timer = sol.timer.start(map, timer_delay, timer_callback)
  timer:set_with_sound(true)
end

-- sensors that close doors
function close_door_b_sensor:on_activated()

  if door_b_passed and stupid_run_door_b:is_open() then
    door_b_passed = false
    close_door_b()
  end
end

function close_door_c_sensor:on_activated()

  if door_c_passed and stupid_run_door_c:is_open() then
    door_c_passed = false
    close_door_c()
  end
end

-- sensors that stop timers (i.e. a door is reached on time)
function stop_timer_a_sensor:on_activated()
  door_a_passed = true
end
stop_timer_a_sensor_2.on_activated = stop_timer_a_sensor.on_activated

function stop_timer_b_sensor:on_activated()
  door_b_passed = true
end
stop_timer_b_sensor_2.on_activated = stop_timer_b_sensor.on_activated

function stop_timer_c_sensor:on_activated()
  door_c_passed = true
end
stop_timer_c_sensor_2.on_activated = stop_timer_c_sensor.on_activated

-- save the solid ground location
local function save_solid_ground_sensor_activated(sensor)
  hero:save_solid_ground()
end
for sensor in map:get_entities("save_solid_ground_sensor") do
  sensor.on_activated = save_solid_ground_sensor_activated
end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if item:get_name() == "map" then
    map:start_dialog("dungeon_1.after_map_treasure")
  end
end

function close_door_a()

  if stupid_run_door_a:is_open()
      and not door_a_passed then
    map:close_doors("stupid_run_door_a")
    stupid_run_switch_a:set_activated(false)
  end
end

function close_door_b()

  if stupid_run_door_b:is_open()
      and not door_b_passed then
    map:close_doors("stupid_run_door_b")
    stupid_run_switch_b:set_activated(false)
  end
end

function close_door_c()

  if stupid_run_door_c:is_open()
      and not door_c_passed then
    map:close_doors("stupid_run_door_c")
    stupid_run_switch_b:set_activated(false)
  end
end

