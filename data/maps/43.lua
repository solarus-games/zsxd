local map = ...

----------------------------
-- Caverne maudite script --
----------------------------

function sign:on_interaction()

  map:set_dialog_variable("caverne_maudite.pancarte", map:get_game():get_player_name())
  map:start_dialog("caverne_maudite.pancarte")
end

