local map = ...
local game = map:get_game()

-- Temple of Stupidities 2F SE

function map:on_started(destination_point)

  -- water removed
  if game:get_value("b283") then
    map:set_entities_enabled("water", false)
  end
end

