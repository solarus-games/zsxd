local map = ...

function map:on_npc_interaction(npc_name)

  if not sol.game.savegame_get_boolean(61) then
    map:start_dialog("water_house.give_bottle")
  else
    map:start_dialog("water_house.after")
  end
end

function map:on_dialog_finished(dialog_id)

  if dialog_id == "water_house.give_bottle" then
    sol.map.treasure_give("bottle_2", 2, 61)
  end
end

