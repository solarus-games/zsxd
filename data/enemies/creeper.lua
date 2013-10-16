local enemy = ...

-- Creeper

local explosion_soon = false
local going_hero = false

function enemy:on_created()

  self:set_life(5)
  self:set_damage(1)
  self:create_sprite("enemies/creeper")
  self:set_size(16, 16)
  self:set_origin(8, 13)
  self:set_attack_consequence("explosion", "ignored")
end

function enemy:on_restarted()

  explosion_soon = false
  self:go_random()
  self:check_hero()
end

function enemy:check_hero()

  local hero = self:get_map():get_entity("hero")
  local distance_to_hero = self:get_distance(hero)
  local near_hero = distance_to_hero < 40

  if distance_to_hero < 160 and not going_hero then
    self:go_hero()
  elseif distance_to_hero >= 160 and going_hero then
    self:go_random()
  end

  if not near_hero and distance_to_hero < 80 then
    local x, y = self:get_position()
    local hero_x, hero_y = hero:get_position()
    if hero_y < y and y - hero_y >= 40 then
      near_hero = true
    end
  end

  if near_hero and not explosion_soon then
    explosion_soon = true
    self:get_sprite():set_animation("hurt")
    sol.audio.play_sound("creeper")
    sol.timer.start(self, 600, function()
      self:explode_if_near_hero()
    end)
  else
    sol.timer.start(self, 100, function()
      self:check_hero()
    end)
  end
end

function enemy:explode_if_near_hero()

  local map = self:get_map()
  local hero = map:get_entity("hero")
  local distance = self:get_distance(hero)
  local near_hero = distance < 70

  if not near_hero and distance < 90 then
    local x, y = self:get_position()
    local hero_x, hero_y = hero:get_position()
    if hero_y < y and y - hero_y >= 20 then
      near_hero = true
    end
  end

  if not near_hero then
    -- cancel the explosion
    explosion_soon = false
    sol.timer.start(self, 400, function()
      self:check_hero()
    end)
    self:get_sprite():set_animation("walking")
  else
    -- explode
    local x, y, layer = self:get_position()
    sol.audio.play_sound("explosion")
    map:create_explosion({ x = x,      y = y - 16, layer = layer})
    map:create_explosion({ x = x + 32, y = y - 16, layer = layer})
    map:create_explosion({ x = x + 24, y = y - 40, layer = layer})
    map:create_explosion({ x = x,      y = y - 48, layer = layer})
    map:create_explosion({ x = x - 24, y = y - 40, layer = layer})
    map:create_explosion({ x = x - 32, y = y - 16, layer = layer})
    map:create_explosion({ x = x - 24, y = y +  8, layer = layer})
    map:create_explosion({ x = x,      y = y + 16, layer = layer})
    map:create_explosion({ x = x + 24, y = y +  8, layer = layer})
    self:remove()
  end
end

function enemy:go_random()

  local movement = sol.movement.create("random_path")
  movement:set_speed(40)
  movement:start(self)
  going_hero = false
end

function enemy:go_hero()
  
  local movement = sol.movement.create("target")
  movement:set_speed(40)
  movement:start(self)
  going_hero = true
end

