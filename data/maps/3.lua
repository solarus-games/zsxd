local map = ...

------------------------------
-- Outside fields SO script --
------------------------------

-- Function called when the map starts.
-- The NPCs are initialized.
function map:on_map_started(destination_point)
  -- make the NPCs walk
  if sol.game.savegame_get_boolean(48) then
    random_monkey_run(48) -- the monkey has not the boots anymore
  else
    random_monkey_run(128)
  end
end

function random_monkey_run(speed)

  local m = sol.main.random_path_movement_create(speed)
  sol.map.npc_start_movement("forest_monkey", m)
  sol.map.npc_get_sprite("forest_monkey"):set_animation("walking")
end


-- Function called when the player wants to talk to a non-playing character.
function map:on_npc_interaction(npc_name)
  if npc_name == "guard" then
    if sol.map.hero_get_direction() == 0 then
      map:start_dialog("outside_fields_SO.guard_ok")
    else
      map:start_dialog("outside_fields_SO.guard_nok")
    end
  elseif npc_name == "forest_monkey" then
    sol.main.play_sound("monkey")
    if sol.game.savegame_get_boolean(48) then -- has boots
      map:start_dialog("outside_fields_SO.forest_monkey_end")
    elseif sol.game.get_item_amount("apple_pie_counter") > 0 then -- has apple pie
      map:start_dialog("outside_fields_SO.forest_monkey_give_boots")
    else
      map:start_dialog("outside_fields_SO.forest_monkey_start")
    end
  end
end

-- Function called when the dialog box is being closed.
-- If the player was talking to the guard, we do the appropriate action
function map:on_dialog_finished(dialog_id, answer)
  if dialog_id == "outside_fields_SO.guard_ok" then

    local s = sol.map.npc_get_sprite("guard")
    if s:get_animation() ~= "walking" then
      -- make the guard move
      local m = sol.main.path_movement_create("000000000066", 24)
      s:set_animation("walking")
      sol.map.npc_start_movement("guard", m)
    end
  elseif dialog_id == "outside_fields_SO.forest_monkey_give_boots" then
    sol.map.treasure_give("pegasus_shoes", 1, 48)
    sol.game.remove_item_amount("apple_pie_counter", 1)
  end
end

function map:on_chest_empty(chest_name)
   if chest_name == "chest_link_house" then
    map:start_dialog("outside_fields_SO.chest_link_house")
    sol.map.hero_unfreeze()
  end
end

function map:on_treasure_obtained(item_name, variant, savegame_variable)

  if item_name == "pegasus_shoes" then
    random_monkey_run(48) -- reduce the speed
  end
end

