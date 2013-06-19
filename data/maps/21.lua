local map = ...
local game = map:get_game()

----------------------------------
-- Crazy House 1FB (north)      --
----------------------------------

-- Guichet 41 -------------------------------------------------
local function guichet_41()

  if game:get_value("i1410") == 3 then
    map:start_dialog("crazy_house.guichet_41_ech_eq_3")
    game:set_value("i1410", 4)
  else
    map:start_dialog("crazy_house.guichet_41_ech_ne_3")
  end
end

-- Guichet 43 -------------------------------------------------
local function guichet_43()

  map:start_dialog("crazy_house.guichet_43", function()
    -- Pipelette qui se tourne vers Link, énervée
    GC43S:get_sprite():set_direction(3)
    map:start_dialog("crazy_house.guichet_43n", function()
      -- Pipelette reprend sa conversation
      GC43S:get_sprite():set_direction(2)
      map:start_dialog("crazy_house.guichet_43f")
    end)
  end)
end

-- Guichet 45 -------------------------------------------------
local function guichet_45()

  if game:get_value("i1410") == 3 then
    map:start_dialog("crazy_house.guichet_45_ech_eq_3")
  else
    map:start_dialog("crazy_house.guichet_45_ech_ne_3", function(answer)
      if answer == 1 then
        if game:get_item("cuillere_counter"):has_amount(1) then
          map:start_dialog("crazy_house.guichet_45_ech_ok", function()
            hero:start_treasure("sac_olive")
            game:get_item("cuillere_counter"):remove_amount(1)
          end)
        else
          sol.audio.play_sound("wrong")
          map:start_dialog("crazy_house.guichet_45_ech_un")
        end
      end
    end)
  end

  -- Incrémentation branche 1412
  local branche1412 = game:get_value("i1412") or 0
  if branche1412 > 0 and branche1412 <= 3 then
    game:set_value("i1412", 4)
  end
end

-- Guichet 47 -------------------------------------------------
local function guichet_47()

  if game:get_value("i1410") == 3 then
    map:start_dialog("crazy_house.guichet_47_ech_eq_3")
  else
    map:start_dialog("crazy_house.guichet_47_ech_ne_3")
  end
end

-- Guichet 49 -------------------------------------------------
local function guichet_49()

  map:start_dialog("crazy_house.guichet_49")
end

function mario_message_2:on_interaction()
  -- Tableau de mario qui parle ---------------------------------
  sol.audio.play_sound("sm64_heehee")
end

function GC41:on_interaction()
  guichet_41()
end

function GC43:on_interaction()
  guichet_43()
end

function GC45:on_interaction()
  guichet_45()
end

function GC47:on_interaction()
  guichet_47()
end

function GC49:on_interaction()
  guichet_49()
end

