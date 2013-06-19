local map = ...

----------------------------------
-- Crazy House 2FA (south)      --
----------------------------------

local game = map:get_game()
local locked_door_A_value = 0

function map:on_started(destination_point)

  -- Interrupteurs
  if self:get_game():get_value("b127") then
    locked_door_switch_A:set_activated()
    locked_door_switch_B:set_activated()
  end
end

-- Vieillard --------------------------------------------------
local function vieillard()

  local branche1411 = game:get_value("i1411") or 0

  if branche1411 >= 1 then
    if not game:get_value("b124") then
      -- Première rencontre
      map:start_dialog("crazy_house.vieillard")
      game:set_value("b124", true)
    else
      if not game:get_value("b125") then
        -- Vieillard n'a pas encore changé d'avis
        if not game:get_item("poivron_counter"):has_amount(1) then
          -- N'a pas encore de poivron
          map:start_dialog("crazy_house.vieillard")
        else
          -- A le poivron
          map:start_dialog("crazy_house.vieillard_poivron")
          -- Changement d'avis
          game:set_value("b125", true)
        end
        -- Incrémentation branche 1411
        if branche1411 > 0 and branche1411 <= 1 then
          game:set_value("i1411", 2)
        end
      else
        -- Vieillard veut du riz maintenant !
        if not game:get_item("sac_riz_counter"):has_amount(1) then
          map:start_dialog("crazy_house.vieillard_riz_quantite")
        else
          -- A le sac de riz
          map:start_dialog("crazy_house.vieillard_riz_ok", function()
            hero:start_treasure("bocal_epice")
            game:get_item("sac_riz_counter"):remove_amount(1)
            -- branche 1411 finie
            if game:get_item("balai_counter"):has_amount(1) then
              game:set_value("i1410", 9)
            end
            game:set_value("i1411", 10)
          end)
        end
        -- Incrémentation branche 1411
        if branche1411 > 0 and branche1411 <= 8 then
          game:set_value("i1411", 9)
        end
      end
    end
  else
    map:start_dialog("crazy_house.vieillard_ronfl")
  end
end

-- Guichet 21 -------------------------------------------------
local function guichet_21()

  if game:get_value("i1410") == 1 then
    map:start_dialog("crazy_house.guichet_21_ech_eq_1")
    game:set_value("i1410", 2)
  else
    map:start_dialog("crazy_house.guichet_21_ech_ne_1")
  end
end

-- Guichet 22A -------------------------------------------------
local function guichet_22A()

  -- Incrémentation branche 1412
  local branche1412 = game:get_value("i1412") or 0
  if branche1412 > 0 and branche1412 <= 1 then
    game:set_value("i1412", 2)
  end

  map:start_dialog("crazy_house.guichet_22A", function(answer)
    if answer == 1 then
      if not game:get_item("roc_magma_counter"):has_amount(1) then
        sol.audio.play_sound("wrong")
        map:start_dialog("crazy_house.guichet_22_rm_un")
      else
        map:start_dialog("crazy_house.guichet_22_rm_ok", function()
          hero:start_treasure("balai")
          game:get_item("roc_magma_counter"):remove_amount(1)
          -- branche 1412 finie
          if game:get_item("bocal_epice_counter"):has_amount(1) then
            game:set_value("i1410", 9)
          end
        end)
      end
    end
  end)
end

-- Guichet 22B -------------------------------------------------
local function guichet_22B()

  -- Incrémentation branche 1411
  local branche1411 = game:get_value("i1411") or 0
  if branche1411 > 0 and branche1411 <= 3 then
    game:set_value("i1411", 4)
  end

  -- Incrémentation branche 1412
  local branche1412 = game:get_value("i1412") or 0
  if branche1412 == 6 then
    game:set_value("i1412", 7)
  end

  map:start_dialog("crazy_house.guichet_22B", function(answer)
    if answer == 1 then
      if not game:get_item("sac_riz_counter"):has_amount(1) then
        sol.audio.play_sound("wrong")
        map:start_dialog("crazy_house.guichet_22_sr_un")
      else
        map:start_dialog("crazy_house.guichet_22_sr_ok", function()
          hero:start_treasure("tapisserie")
          game:get_item("sac_riz_counter"):remove_amount(1)
          -- Incrémentation branche 1411
          local branche1411 = game:get_value("i1411") or 0
          if branche1411 > 0 and branche1411 <= 5 then
            game:set_value("i1411", 6)
          end
          -- Incrémentation branche 1412
          local branche1412 = game:get_value("i1412") or 0
          if branche1412 >= 6 and branche1412 <= 8 then
            game:set_value("i1412", 9)
          end
        end)
      end
    end
  end)
end

-- Interactions avec capteur pour guichet (devanture) ou NPC
GC21front.on_interaction = guichet_21
GC22A.on_interaction = guichet_22A
GC22B.on_interaction = guichet_22B
Vieillard.on_interaction = vieillard
GC21.on_interaction = guichet_21

-- Mécanisme du coffre farceur dans la salle aux trois portes        
function prankster_sensor_top:on_activated()
  prankster_chest:set_position(440, 509)
end
prankster_sensor_bottom.on_activated = prankster_sensor_top.on_activated

function prankster_sensor_middle:on_activated()
  prankster_chest:set_position(360, 509)
end

-- Mécanisme de la porte qui s'ouvre grâce à deux boutons
-- dans la salle aux trois portes
function locked_door_switch_A:on_activated()

  if locked_door_A_value < 2 then
    locked_door_A_value = locked_door_A_value + 1
    if locked_door_A_value == 2 and LD1:is_closed() then
      map:open_doors("LD1")
      sol.audio.play_sound("secret")
    end
  end
end
locked_door_switch_B.on_activated = locked_door_switch_A.on_activated

function WW2:on_opened()

  sol.audio.play_sound("secret")
end

