local map = ...

-- Outside SE

local game = map:get_game()
local last_yoda_quote = 0

function map:on_started(destination_point)

  if game:get_value("b65") then
    map:set_entities_enabled("temple_door_tile", false)
    temple_door:remove()
  end

  yoda:get_sprite():set_animation("walking")
end

function temple_door:on_interaction()

  if game:has_item("bone_key") then
    sol.audio.play_sound("door_open")
    sol.audio.play_sound("secret")
    map:set_entities_enabled("temple_door_tile", false)
    temple_door:remove()
    game:set_value("b65", true)
  else
    sol.audio.play_sound("wrong")
    map:start_dialog("outside_fields_SE.temple_door_closed")
  end
end

function yoda:on_interaction()

  if not game:get_value("b66") then
    map:start_dialog("outside_fields_SE.yoda_give_sword", function()
      hero:start_treasure("sword", 2, 66)
    end)
  else
    map:start_dialog("outside_fields_SE.yoda_finished")
  end
end

local function yoda_sensor_activated(sensor)

  -- choose a random quote
  local index
  repeat -- make sure the same quote is not picked again
    index = math.random(11)
  until index ~= last_yoda_quote

  map:start_dialog("outside_fields_SE.yoda_quote_" .. index, callback)
  last_yoda_quote = index
end
for _, sensor in map:get_entities("yoda_sensor") do
  sensor.on_activated = yoda_sensor_activated
end

