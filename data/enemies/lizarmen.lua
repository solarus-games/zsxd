local enemy = ...

-- Lizarmen: parody of the stupid miniboss of the dungeon 2 in Zelda Mystery of Solarus

local total_sons_created = 0
local create_son

function enemy:on_created()

  self:set_life(20)
  self:set_damage(2)
  self:set_hurt_style("boss")
  self:create_sprite("enemies/lizarmen")
  self:set_size(144, 176)
  self:set_origin(77, 165)
  self:set_pushed_back_when_hurt(false)
end

function enemy:on_restarted()

  -- yes, there is no movement :)
  sol.timer.start(self, 1000, create_son)
end

function enemy:on_hurt(attack, life_lost)

  if self:get_life() <= 0 then
    local sons_prefix = self:get_name() .. "_son_"
    self:get_map():remove_entities(sons_prefix)
    sol.timer.stop_all(self)
  end
end

function create_son()

  local nb_current_sons = enemy:get_map():get_entities_count(enemy:get_name() .. "_son")

  if nb_current_sons < 30 then
    total_sons_created = total_sons_created + 1
    son_name = enemy:get_name() .. "_son_" .. total_sons_created
    local son = enemy:create_enemy{
      name = son_name,
      breed = "tentacle",
      x = 0,
      y = -77
    }
    son:set_treasure("heart")
  end

  sol.timer.start(enemy, 1000, create_son)
end

