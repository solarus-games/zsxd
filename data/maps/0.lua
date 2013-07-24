local map = ...
local game = map:get_game()

-- Link's house

local bed_sprite = nil

function map:on_started(destination_point)

  if destination_point ~= nil
      and destination_point:get_name() == "start_position" then
    -- intro
    snores:get_sprite():set_ignore_suspend(true)
    bed:get_sprite():set_animation("hero_sleeping")
    hero:freeze()
    hero:set_visible(false)
    sol.audio.play_music("triforce")
    sol.timer.start(map, 3000, function()
      game:start_dialog("link_house.intro", function()
        sol.timer.start(map, 2000, function()
          sol.audio.play_music("village")
          snores:remove()
          bed:get_sprite():set_animation("hero_waking")
          sol.timer.start(map, 500, function()
            hero:set_visible(true)
            hero:start_jumping(0, 8, true)
            map:set_pause_enabled(true)
            bed:get_sprite():set_animation("empty_open")
            sol.audio.play_sound("hero_lands")
            bed:set_position(56, 101)
          end)
        end)
      end)
    end)
  else
    snores:remove()
    sol.audio.play_music("village")
    bed:set_position(56, 101)
  end
end

