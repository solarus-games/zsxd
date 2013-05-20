local map = ...

-- Temple of Stupidities 2F NW

function map:on_started(destination_point)

  sol.map.light_set(0)
end

function map:on_switch_activated(switch_name)

  sol.audio.play_sound("secret")
  sol.map.door_open("creeper_door")
end

function map:on_hero_on_sensor(sensor_name)

  if sol.map.door_is_open("creeper_door")
      and sol.map.hero_get_direction() == 2 then
    sol.map.door_close("creeper_door")
  end
end

