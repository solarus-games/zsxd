local map = ...
local game = map:get_game()

-- Water house.

function water_guy:on_interaction()

  if not game:get_value("b61") then
    map:start_dialog("water_house.give_bottle", function()
      hero:start_treasure("bottle_2", 2, "b61")
    end)
  else
    map:start_dialog("water_house.after")
  end
end

