local map = ...

-- Shop

function map:on_started(destination_point)
   -- make the NPCs walk
   local movement = sol.movement.create("random_path")
   movement:set_speed(32)
   movement:start(lady_a)
end

