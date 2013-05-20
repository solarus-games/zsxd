local item = ...

function item:on_created()

  self:set_savegame_variable("i1107")
  self:set_assignable(true)
end

function item:on_using()

  local hero = self:get_map():get_entity("hero")
  hero:set_direction(math.random(0, 3))
  hero:start_running()
  self:set_finished()
end

