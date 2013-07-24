local map = ...
local game = map:get_game()

----------------------------
-- Caverne maudite script --
----------------------------

function sign:on_interaction()

  game:start_dialog("caverne_maudite.pancarte", game:get_player_name())
end

