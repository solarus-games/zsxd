local map = ...

-- Temple of Stupidities 2F NW

function map:on_started(destination_point)

  map:set_light(0)
end

function creeper_door_switch:on_activated()

  sol.audio.play_sound("secret")
  map:open_doors("creeper_door")
end

function close_creeper_room_door_sensor:on_activated()

  if creeper_door:is_open()
      and hero:get_direction() == 2 then
    map:close_doors("creeper_door")
  end
end

