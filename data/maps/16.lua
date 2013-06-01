local map = ...
local game = map:get_game()

-- Desert east house

function npc:on_interaction()

  if game:get_value("b59") then
    -- door already open
    map:start_dialog("desert.east_house.bone_key")
  elseif game:get_value("b60") then
    -- died in the cursed cave
    map:start_dialog("desert.east_house.back_from_dead", function()
      map:open_doors("door")
    end)
  else
    map:start_dialog("desert.east_house.first_time")
  end
end

