local map = ...

-- Temple of Stupidities 2F SE

function map:on_started(destination_point)

  -- water removed
  if game:get_value("b283") then
    sol.map.tile_set_group_enabled("water", false)
  end
end

