local map = ...

-- Desert east house

function map:on_npc_interaction(npc_name)

  if sol.game.savegame_get_boolean(59) then
    -- door already open
    map:start_dialog("desert.east_house.bone_key")
  elseif sol.game.savegame_get_boolean(60) then
    -- died in the cursed cave
    map:start_dialog("desert.east_house.back_from_dead")
  else
    map:start_dialog("desert.east_house.first_time")
  end
end

function map:on_dialog_finished(dialog_id)

  if dialog_id == "desert.east_house.back_from_dead" then
    sol.map.door_open("door")
  end
end
