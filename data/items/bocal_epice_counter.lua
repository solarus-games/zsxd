local item = ...

function item:on_created()

  self:set_savegame_variable("1488")
  self:set_amount_savegame_variable("1478")
  self:set_max_amount(50)
end

