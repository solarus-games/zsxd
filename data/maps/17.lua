local map = ...
local game = map:get_game()

-- The end

function map:on_started(destination_point)

  game:set_hud_enabled(false)
  hero:freeze()
  game:set_life(game:get_max_life())
  game:save()
  sol.audio.play_sound("hero_dying")
  sol.timer.start(map, 7000, function()
    map:start_dialog("the_end.credits", function()
      sol.main.reset()
    end)
  end)
end

