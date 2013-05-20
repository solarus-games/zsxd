local item = ...

function item:on_created()

  self:set_savegame_variable("i1487")
  self:set_amount_savegame_variable("1477")
  self:set_max_amount(50)
end

