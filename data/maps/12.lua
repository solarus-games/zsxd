local map = ...
local game = map:get_game()

-- Link's cave

function map:on_started(destination_point)

  zelda_enemy:set_enabled(false)
  map:set_doors_open("door", true)
end

function map:on_treasure_obtained(item_name, variant, savegame_variable)

  if item_name == "zelda" then
    sol.audio.play_music("boss")
    zelda:set_position(224, 85)
    hero:freeze()
    game:add_life(80)
    sol.timer.start(map, 1000, function()
      map:start_dialog("link_cave.angry_zelda", function()

        map:close_doors("door")
        zelda:get_sprite():set_animation("walking")
        local movement = sol.movement.create("jump_movement")
        movement:set_direction(6)
        movement:set_jump_length(24)
        movement:set_ignore_obstacles(true)
        movement:set_speed(48)
        movement:start(zelda, function()
          zelda:set_position(-100, -100) -- disable the NPC
          hero:unfreeze()
          zelda_enemy:set_enabled(true)
        end)

      end)
    end)
  end
end

function map:on_update()

  if door:is_closed() and game:get_life() <= 4 then
    -- go to the end screen
    hero:teleport("17", "start_position")
  end
end

