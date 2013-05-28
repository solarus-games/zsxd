local map = ...
local game = map:get_game()

----------------------------------
-- FREAKING CAVE 1 OMG          --
-- USE BOOLEAN FROM 90 TO 99    --
----------------------------------

function map:on_started(destination_point)

  local torch1 = fc_torch_1:get_sprite()
  local torch2 = fc_torch_2:get_sprite()

  -- Few light inside the cave at start
  if not game:get_value("b90") then
    self:set_light(1)         
    torch1:set_animation("lit")
    torch2:set_animation("lit")
  else        
    self:set_light(0)
    torch1:set_animation("unlit")
    torch2:set_animation("unlit")
    sensor_light_off:set_enabled(false)
  end        

  torch2:set_animation("lit")
end

function sensor_light_off:on_activated()

  -- Map in deep dark
  map:set_light(0)
  torch1:set_animation("unlit")
  torch2:set_animation("unlit")
  sensor_light_off:set_enabled(false)
  game:set_value("b90", true)
end

