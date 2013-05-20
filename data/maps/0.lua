local map = ...

-- Link's house

local bed_sprite = nil

function map:on_map_started(destination_point)

  local bed_sprite = sol.map.npc_get_sprite("bed")
  if destination_point:get_name() == "start_position" then
    -- intro
    local snores_sprite = sol.map.npc_get_sprite("snores")
    snores_sprite:set_ignore_suspend(true)
    bed_sprite:set_animation("hero_sleeping")
    sol.map.hero_freeze()
    sol.map.hero_set_visible(false)
    sol.audio.play_music("triforce")
    sol.main.timer_start(intro, 3000)
  else
    sol.map.npc_remove("snores")
    sol.audio.play_music("village")
    sol.map.npc_set_position("bed", 56, 101)
  end
end

function intro()
  map:start_dialog("link_house.intro")
end

function map:on_dialog_finished(dialog_id)

  if dialog_id == "link_house.intro" then
    sol.main.timer_start(wake_up, 2000)
  end
end

function wake_up()

  local bed_sprite = sol.map.npc_get_sprite("bed")
  sol.audio.play_music("village")
  sol.map.npc_remove("snores")
  bed_sprite:set_animation("hero_waking")
  sol.main.timer_start(jump_from_bed, 500)
end

function jump_from_bed()

  local bed_sprite = sol.map.npc_get_sprite("bed")
  sol.map.hero_set_visible(true)
  sol.map.hero_start_jumping(0, 8, true)
  sol.map.hud_set_pause_enabled(true)
  bed_sprite:set_animation("empty_open")
  sol.main.play_sound("hero_lands")
  sol.map.npc_set_position("bed", 56, 101)
end

