local enemy = ...
-- Zelda

local sprite

function enemy:on_created()

  self:set_life(100)
  self:set_damage(8)
  self:set_size(16, 16)
  self:set_origin(8, 13)
  self:set_invincible()
  sprite = self:create_sprite("enemies/zelda")
end

function enemy:on_restarted()

  local movement = sol.movement.create("path_finding")

  function movement:on_changed()
    sprite:set_direction(self:get_direction4())
  end

  movement:set_speed(64)
  movement:start(self)
end

