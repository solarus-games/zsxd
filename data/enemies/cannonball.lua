local enemy = ...

-- Cannonball or random sprite
-- made for the ALTTP room in Temple of Stupidities 1F NE

local random_balls = {
  {
    sprite = "enemies/cannonball",
    sound = "cannonball",
    width = 16,
    height = 16,
    origin_x = 8,
    origin_y = 13,
    dx = -8,
    dy = 0
  },
  {
    sprite = "enemies/cannonball",
    sound = "cannonball",
    width = 16,
    height = 16,
    origin_x = 8,
    origin_y = 13,
    dx = 8,
    dy = 0
  },
  {
    sprite = "enemies/cannonball_big",
    sound = "cannonball",
    width = 32,
    height = 32,
    origin_x = 16,
    origin_y = 29,
    dx = 0,
    dy = 0
  },
  {
    sprite = "enemies/dkc_bananas",
    sound = "cannonball",
    width = 32,
    height = 32,
    origin_x = 16,
    origin_y = 29,
    dx = 0,
    dy = 0
  },
  {
    sprite = "enemies/dkc_barrel",
    sound = "cannonball",
    width = 32,
    height = 40,
    origin_x = 16,
    origin_y = 29,
    dx = 0,
    dy = 8
  },
  {
    sprite = "enemies/mc_pickaxe",
    sound = "cannonball",
    width = 32,
    height = 32,
    origin_x = 16,
    origin_y = 29,
    dx = 0,
    dy = 0
  },
  {
    sprite = "enemies/smb_block",
    sound = "smb_coin",
    width = 16,
    height = 16,
    origin_x = 8,
    origin_y = 13,
    dx = -8,
    dy = 0
  },
  {
    sprite = "enemies/smb_block",
    sound = "smb_coin",
    width = 16,
    height = 16,
    origin_x = 8,
    origin_y = 13,
    dx = 8,
    dy = 0
  },
  {
    sprite = "enemies/smk_mario",
    sound = "mk64_mario_yeah",
    width = 32,
    height = 32,
    origin_x = 16,
    origin_y = 29,
    dx = 0,
    dy = 0
  },
  {
    sprite = "enemies/smk_yoshi",
    sound = "mk64_yoshi",
    width = 32,
    height = 32,
    origin_x = 16,
    origin_y = 29,
    dx = 0,
    dy = 0
  },
  {
    sprite = "enemies/smk_toad",
    sound = "mk64_toad",
    width = 32,
    height = 32,
    origin_x = 16,
    origin_y = 29,
    dx = 0,
    dy = 0
  }
}

function enemy:on_created()

  self:set_life(1)
  self:set_damage(0)
  self:set_invincible()
  self:set_optimization_distance(0)  -- This is done manually by the map.

  local index
  if math.random(4) == 4 then
    -- choose between all stupid stuff
    index = math.random(#random_balls)
  else
    -- choose between the 3 real cannonballs
    index = math.random(3)
  end
  local props = random_balls[index]

  self:create_sprite(props.sprite)
  self:set_size(props.width, props.height)
  self:set_origin(props.origin_x, props.origin_y)
  local x, y = self:get_position()
  self:set_position(x + props.dx, y + props.dy)
  sol.audio.play_sound(props.sound)
end

function enemy:on_restarted()

  local movement = sol.movement.create("straight")

  function movement:on_obstacle_reached()
    enemy:remove()
  end
  movement:set_speed(48)
  movement:set_angle(3 * math.pi / 2)
  movement:start(self)
end

