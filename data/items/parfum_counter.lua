local item = ...

function item:on_created()

  self:set_savegame_variable("i1490")
  self:set_amount_savegame_variable("1480")
  self:set_max_amount(50)
end

