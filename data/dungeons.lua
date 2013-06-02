local game = ...

-- Define the existing dungeons and their floors for the minimap menu.
game.dungeons = {
  [1] = {
    floor_width = 3072,
    floor_height = 2048,
    lowest_floor = 0,
    highest_floor = 1,
    maps = { "60", "61", "62", "63", "64", "65", "66", "67" },
    boss = {
      floor = 1,
      x = 1088,
      y = 845,
      savegame_variable = "b306",
    },
  },
  [2] = {
    floor_width = 3056,
    floor_height = 2064,
    lowest_floor = 0,
    highest_floor = 2,
    maps = { "20", "21", "22", "23", "24" },
  },
}

-- Returns the index of the current dungeon if any, or nil.
function game:get_dungeon_index()

  local world = self:get_map():get_world()
  local index = tonumber(world:match("^dungeon_([0-9]+)$"))
  return index
end

-- Returns the current dungeon if any, or nil.
function game:get_dungeon()

  local index = self:get_dungeon_index()
  return self.dungeons[index]
end

function game:is_dungeon_finished(dungeon_index)
  return self:get_value("dungeon_" .. dungeon_index .. "_finished")
end

function game:set_dungeon_finished(dungeon_index, finished)
  if finished == nil then
    finished = true
  end
  self:set_value("dungeon_" .. dungeon_index .. "_finished", finished)
end

function game:has_dungeon_map(dungeon_index)

  dungeon_index = dungeon_index or self:get_dungeon_index()
  return self:get_value("dungeon_" .. dungeon_index .. "_map")
end

function game:has_dungeon_compass(dungeon_index)

  dungeon_index = dungeon_index or self:get_dungeon_index()
  return self:get_value("dungeon_" .. dungeon_index .. "_compass")
end

function game:has_dungeon_big_key(dungeon_index)

  dungeon_index = dungeon_index or self:get_dungeon_index()
  return self:get_value("dungeon_" .. dungeon_index .. "_big_key")
end

function game:has_dungeon_boss_key(dungeon_index)

  dungeon_index = dungeon_index or self:get_dungeon_index()
  return self:get_value("dungeon_" .. dungeon_index .. "_boss_key")
end

