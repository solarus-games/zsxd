local enemy = ...

-- Ganon in the temple of stupidities (2F NE)

local being_pushed = false
local sprite

function enemy:on_created()

  self:set_life(100000)
  self:set_damage(4)
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
  elseif x > 1176 and not being_pushed then
    self:on_restarted()
  end
end

function enemy:on_custom_attack_received(attack, sprite)

  if attack == "sword" then
    sol.audio.play_sound("sword_tapping")
    being_pushed = true
    local hero = self:get_map():get_entity("hero")
    local angle = hero:get_angle(self)
    local movement = sol.movement.create("straight")
    movement:set_angle(128)
    movement:set_max_distance(26)
    movement:start(self)
  end
end

function enemy:on_movement_changed(movement)

  if not being_pushed then
    local direction4 = movement:get_displayed_direction()
    if direction4 == 1 then
      sprite:set_direction(1)
    else
      sprite:set_direction(0)
    end
  end
end

function enemy:on_movement_finished()

  if being_pushed then
    self:on_restarted()
  end
end

function enemy:on_obstacle_reached()

  if being_pushed then
    self:on_restarted()
  end
end

