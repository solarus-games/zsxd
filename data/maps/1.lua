local map = ...

------------------------------
-- Outside fields NO script --
------------------------------

local function random_walk(npc)
  local movement = sol.movement.create("random_path")
  movement:set_speed(32)
  movement:start(npc)
end

-- Function called when the map starts.
-- The NPCs are initialized.
function map:on_started(destination_point)
  -- make the NPCs walk
  random_walk(lady_b)
  random_walk(guy_a)
end

