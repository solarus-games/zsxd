local enemy = ...

-- Ganon in the temple of stupidities (2F NE)

local sprite

function enemy:on_created()

  self:set_life(100000)
  self:set_damage(4)
  self:set_hurt_style("boss")
  self:set_size(16, 16)
  self:set_origin(8, 13)
  self:set_invincible()
  self:set_attack_consequence("sword", "custom")
  self:set_attack_consequence("arrow", 1)
  sprite = self:create_sprite("enemies/ganon")
end

function enemy:on_restarted()

  local movement = sol.movement.create("path_finding")
  movement:set_speed(32)
  movement:start(self)
end

function enemy:on_update()

  local x, y = self:get_position()
  if x > 1216 and self:get_life() > 0 then
    self:set_position(x, y, 0) -- go to low layer
    self:set_life(0)
    sprite:set_animation("hurt")
    sol.audio.play_sound("boss_killed")
  end
end

function enemy:on_custom_attack_received(attack, sprite)

  if attack == "sword" then
    sol.audio.play_sound("sword_tapping")
    local hero = self:get_map():get_entity("hero")
    local angle = hero:get_angle(self)
    local movement = sol.movement.create("straight")
    movement:set_speed(128)
    movement:set_angle(angle)
    movement:set_max_distance(26)
    movement:start(self)
  end
end

function enemy:on_movement_finished()

  self:on_restarted()
end

function enemy:on_obstacle_reached()

  self:on_restarted()
end

