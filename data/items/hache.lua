local item = ...

function item:on_obtaining(variant, savegame_variable)

  local counter = self:get_game():get_item(self:get_name() .. "_counter")
  if counter:get_variant() == 0 then
    counter:set_variant(1)
  end
  counter:add_amount(1)
end

