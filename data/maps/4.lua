local map = ...

-- Outside SE

local last_yoda_quote = 0

function map:on_map_started(destination_point)

  if game:get_value("b65") then
    sol.map.tile_set_enabled("temple_door_tile", false)
    sol.map.npc_remove("temple_door")
  end

  local yoda_sprite = sol.map.npc_get_sprite("yoda")
  yoda_sprite:set_animation("walking")
end

function map:on_npc_interaction(npc_name)

  if npc_name == "temple_door" then
    if sol.game.has_item("bone_key") then
      sol.main.play_sound("door_open")
      sol.main.play_sound("secret")
      sol.map.tile_set_enabled("temple_door_tile", false)
      sol.map.npc_remove("temple_door")
      game:set_value("b65", true)
    else
      sol.main.play_sound("wrong")
      map:start_dialog("outside_fields_SE.temple_door_closed")
    end

  elseif npc_name == "yoda" then
    if not game:get_value("b66") then
      map:start_dialog("outside_fields_SE.yoda_give_sword")
    else
      map:start_dialog("outside_fields_SE.yoda_finished")
    end
  end
end

function map:on_hero_on_sensor(sensor_name)

  if string.find(sensor_name, "^yoda_sensor") then

    -- choose a random quote
    local index
    repeat -- make sure the same quote is not picked again
      index = math.random(11)
    until index ~= last_yoda_quote
    map:start_dialog("outside_fields_SE.yoda_quote_" .. index)
    last_yoda_quote = index
  end
end

function map:on_dialog_finished(dialog_id)

  if dialog_id == "outside_fields_SE.yoda_give_sword" then
    sol.map.treasure_give("sword", 2, 66)
  end
end

