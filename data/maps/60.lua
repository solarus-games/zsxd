local map = ...

-- Temple of Stupidities 1F NW

local switches_good_order = {
  3,1,4,2,3,2,1,1,4,3,2,2,
  1,3,2,3,3,1,4,4,2,1,2,3,
  3,2,1,1,3,4,2,2,1,3,4,1
}
local next_switch_index = 1

local function switch_activated(switch)

  local switch_index = switch:get_name():match("^switch_([1-4])$")
  if switch_index ~= nil and next_switch_index <= #switches_good_order then
 
    switch_index = tonumber(switch_index)
    if switch_index == switches_good_order[next_switch_index] then
      next_switch_index = next_switch_index + 1
    else
      next_switch_index = 1
    end

    if next_switch_index == 5 and code_door:is_closed() then
      game:start_dialog("dungeon_1.big_code_ok", function()
        map:move_camera(1072, 456, 250, function()
          map:open_doors("code_door")
          sol.audio.play_sound("secret")
        end)
      end)
    elseif next_switch_index > #switches_good_order then
      game:start_dialog("dungeon_1.big_code_completed")
    end

    switch:set_activated(false)
  end
end
for i = 1, 4 do
  map:get_entity("switch_" .. i).on_activated = switch_activated
end

local function save_solid_ground_sensor_activated(sensor)

  if sensor:get_name():find("^save_solid_ground_sensor") then
    hero:save_solid_ground()
  end
end
for sensor in map:get_entities("save_solid_ground_sensor") do
  sensor.on_activated = save_solid_ground_sensor_activated
end

