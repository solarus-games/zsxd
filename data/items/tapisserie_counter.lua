local item = ...

function item:on_created()

  self:set_savegame_variable("i1484")
  self:set_amount_savegame_variable("i1474")
  self:set_max_amount(50)
end

