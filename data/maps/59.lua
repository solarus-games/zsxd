local map = ...

-- Caverne maudite -16

function map:on_started()
  -- before dying, save the fact that the cursed cave vas visited
  self:get_game():set_value("b60", true)
end

function map:on_update()

  if self:get_game():is_game_over_enabled() then
    --- Let the fairy restore some life.
    return
  end

  -- Make sure the hero will die in the lava
  -- even if a fairy saves him
  if self:get_game():get_life() > 1 then
    self:get_game():set_life(1)
  end
end


