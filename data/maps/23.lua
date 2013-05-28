local map = ...
local game = map:get_game()

----------------------------------
-- Crazy House 2FB (north)      --
----------------------------------

-- Guichet 82 -------------------------------------------------
local function guichet_82()

  map:start_dialog("crazy_house.guichet_82", function(answer)

    -- Choix de réponse au guichet 82
    if answer == 1 then
      -- Contrôle de la quantité
      if not game:get_item("sac_olive_counter"):has_amount(1) then
        sol.audio.play_sound("wrong")
        map:start_dialog("crazy_house.guichet_82_un")
      else
        map:start_dialog("crazy_house.guichet_82_ok", function()
          -- Obtention du roc magma au guichet 82
          hero:start_treasure("roc_magma")
          game:get_item("sac_olive_counter"):remove_amount(1)
        end)
      end
    end

  end)
  -- Incrémentation branche 1412
  local branche1412 = game:get_value("i1412")
  if branche1412 > 0 and branche1412 <= 2 then
    game:set_value("i1412", 3)
  end
end

-- Guichet 84 -------------------------------------------------
local function guichet_84()

  if game:get_value("i1410") == 3 then
    map:start_dialog("crazy_house.guichet_84_ech_eq_3")
  else
    if game:get_item("hache_counter"):has_amount(1) then
      map:start_dialog("crazy_house.guichet_84_ech_ne_3_hh", function(answer)

        -- Choix de réponse au guichet 84
        if answer == 1 then
          -- Contrôle de la quantité
          if not game:get_item("hache_counter"):has_amount(1) then
            sol.audio.play_sound("wrong")
            map:start_dialog("crazy_house.guichet_84_ech_ne_3_un")
          else
            hero:start_treasure("poivron")
            game:get_item("hache_counter"):remove_amount(1)
            -- Incrémentation branche 1411
            local branche1411 = game:get_value("i1411")
            if branche1411 > 0 and branche1411 <= 7 then
              game:set_value("i1411", 8)
            end
          end
        end

      end)
    else
      map:start_dialog("crazy_house.guichet_84_ech_ne_3_nh")
    end
  end
end

function GC82:on_interaction()
  guichet_82()
end

function GC82Front:on_interaction()
  GC82:get_sprite():set_direction(3)
  guichet_82()
end

function GC84:on_interaction()
  guichet_84()
end

