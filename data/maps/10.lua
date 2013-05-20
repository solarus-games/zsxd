local map = ...

function map:on_npc_interaction(npc_name)

  if not game:get_value("b61") then
    map:start_dialog("water_house.give_bottle")
  else
    map:start_dialog("water_house.after")
  end
end

function map:on_dialog_finished(dialog_id)

  if dialog_id == "water_house.give_bottle" then
    hero:start_treasure("bottle_2", 2, 61)
  end
end

