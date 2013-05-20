local map = ...

----------------------------
-- Caverne maudite script --
----------------------------

function map:on_npc_interaction(npc_name)

  if npc_name == "sign" then
    sol.map.dialog_start("caverne_maudite.pancarte")
    sol.map.dialog_set_variable("caverne_maudite.pancarte", sol.game.savegame_get_name())
  end
end

