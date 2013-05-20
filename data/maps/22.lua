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

  if game:get_value("i1411") >= 1 then
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
        local branche1411 = game:get_value("i1411")
        if branche1411 > 0 and branche1411 <= 1 then
          game:set_value("i1411", 2)
        end
      else
        -- Vieillard veut du riz maintenant !
        if not game:get_item("sac_riz_counter"):has_amount(1) then
          map:start_dialog("crazy_house.vieillard_riz_quantite")
        else
          -- A le sac de riz
          map:start_dialog("crazy_house.vieillard_riz_ok")
        end
        -- Incrémentation branche 1411
        local branche1411 = game:get_value("i1411")
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

  map:start_dialog("crazy_house.guichet_22A")
  -- Incrémentation branche 1412
  local branche1412 = game:get_value("i1412")
  if branche1412 > 0 and branche1412 <= 1 then
    game:set_value("i1412", 2)
  end
end

-- Guichet 22B -------------------------------------------------
function guichet_22B()

  map:start_dialog("crazy_house.guichet_22B")
  -- Incrémentation branche 1411
  local branche1411 = game:get_value("i1411")
  if branche1411 > 0 and branche1411 <= 3 then
    game:set_value("i1411", 4)
  end
  -- Incrémentation branche 1412
  local branche1412 = game:get_value("i1412")
  if branche1412 == 6 then
    game:set_value("i1412", 7)
  end
end

-- Interactions avec capteur pour guichet (devanture) ou NPC
function map:on_npc_interaction(npc_name)

  if npc_name == "GC21front" then
    guichet_21()
  elseif npc_name == "GC22A" then
    guichet_22A()
  elseif npc_name == "GC22B" then
    guichet_22B()
  elseif npc_name == "Vieillard" then
    vieillard()
  elseif npc_name == "GC21" then
    guichet_21()
  end
end

function map:on_dialog_finished(dialog_id, answer)

  if dialog_id == "crazy_house.vieillard_riz_ok" then
    sol.map.treasure_give("bocal_epice", 1, -1)
    sol.game.remove_item_amount("sac_riz_counter", 1)
    -- branche 1411 finie
    if sol.game.get_item_amount("balai_counter") > 0 then
      game:set_value("i1410", 9)
    end
    game:set_value("i1411", 10)
  elseif dialog_id == "crazy_house.guichet_22A" then
    if answer == 0 then
      if sol.game.get_item_amount("roc_magma_counter") < 1 then
        sol.main.play_sound("wrong")
        map:start_dialog("crazy_house.guichet_22_rm_un")
      else
        map:start_dialog("crazy_house.guichet_22_rm_ok")
      end
    end
  elseif dialog_id == "crazy_house.guichet_22B" then
    if answer == 0 then
      if sol.game.get_item_amount("sac_riz_counter") < 1 then
        sol.main.play_sound("wrong")
        map:start_dialog("crazy_house.guichet_22_sr_un")
      else
        map:start_dialog("crazy_house.guichet_22_sr_ok")
      end
    end
  elseif dialog_id == "crazy_house.guichet_22_rm_ok" then
    sol.map.treasure_give("balai", 1, -1)
    sol.game.remove_item_amount("roc_magma_counter", 1)
    -- branche 1412 finie
    if sol.game.get_item_amount("bocal_epice_counter") > 0 then
      game:set_value("i1410", 9)
    end
  elseif dialog_id == "crazy_house.guichet_22_sr_ok" then
    sol.map.treasure_give("tapisserie", 1, -1)
    sol.game.remove_item_amount("sac_riz_counter", 1)
    -- Incrémentation branche 1411
    local branche1411 = game:get_value("i1411")
    if branche1411 > 0 and branche1411 <= 5 then
      game:set_value("i1411", 6)
    end
    -- Incrémentation branche 1412
    local branche1412 = game:get_value("i1412")
    if branche1412 >= 6 and branche1412 <= 8 then
      game:set_value("i1412", 9)
    end
  end
end

function map:on_hero_on_sensor(sensor_name)

  -- Mécanisme du coffre farceur dans la salle aux trois portes        
  if sensor_name == "prankster_sensor_top" or sensor_name == "prankster_sensor_bottom" then
    sol.map.npc_set_position("prankster_chest", 440, 509)
  elseif sensor_name == "prankster_sensor_middle" then
    sol.map.npc_set_position("prankster_chest", 360, 509)
  end
end

function map:on_switch_activated(switch_name)

  -- Mécanisme de la porte qui s'ouvre grâce à deux boutons
  -- dans la salle aux trois portes
  if switch_name == "locked_door_switch_A"
    or switch_name == "locked_door_switch_B" then
    if locked_door_A_value < 2 then
      locked_door_A_value = locked_door_A_value + 1
      if locked_door_A_value == 2 and not sol.map.door_is_open("LD1") then
        sol.map.door_open("LD1")
        sol.main.play_sound("secret")
      end
    end
  end
end

function map:on_door_open(door_name)

  if door_name == "WW2" then
    sol.main.play_sound("secret")
  end
end

