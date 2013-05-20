local map = ...

-- The end

function map:on_map_started(destination_point)

  sol.map.hud_set_enabled(false)
  sol.map.hero_freeze()
  sol.game.add_life(sol.game.get_max_life())
  sol.game.save()
  sol.main.timer_start(credits, 7000)
  sol.main.play_sound("hero_dying")
end

function credits()

  map:start_dialog("the_end.credits")
end

function map:on_dialog_finished(dialog_id)

  if dialog_id == "the_end.credits" then
    sol.game.reset()
  end
end

