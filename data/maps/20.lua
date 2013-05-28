local map = ...
local game = map:get_game()

----------------------------------
-- Crazy House 1FA (south)      --
----------------------------------

local guichet_11_error = false

function map:on_started(destination_point)

  if game:get_value("b101") then
    CS3:set_activated(true)
  else
    CK3:set_enabled(false)
  end

  -- Guichetière 12B partie en pause
  if game:get_value("i1410") == 5
      or game:get_value("i1410") == 6 then
    GC12BPerson:remove()
    GC12B:remove()
  end
end

function map:on_opening_transition_finished(destination_point)

  -- Affichage du nom du donjon quand on entre  
  if destination_point == start_position then
    map:start_dialog("crazy_house.title")
  end
end

function CS3:on_activated()
  -- Bouton qui fait apparaitre un coffre contenant la carte (CV3)
  CK3:set_enabled(true)
  game:set_value("b101", true)
  sol.audio.play_sound("chest_appears")
end

local function accueil_branche1()

  if game:get_value("i1411") == 1 then
    map:start_dialog("crazy_house.accueil_epi_eo_1-7")
  elseif game:get_value("i1411") == 2 then
    map:start_dialog("crazy_house.accueil_epi_eo_2-6")
  elseif game:get_value("i1411") == 3 then
    map:start_dialog("crazy_house.accueil_epi_eo_3-5")
  elseif game:get_value("i1411") == 4 then
    map:start_dialog("crazy_house.accueil_epi_eo_4-9")
  elseif game:get_value("i1411") == 5 then
    map:start_dialog("crazy_house.accueil_epi_eo_3-5")
  elseif game:get_value("i1411") == 6 then
    map:start_dialog("crazy_house.accueil_epi_eo_2-6")
  elseif game:get_value("i1411") == 7 then
    map:start_dialog("crazy_house.accueil_epi_eo_1-7")
  elseif game:get_value("i1411") == 8 then
    map:start_dialog("crazy_house.accueil_epi_eo_8-10")
  elseif game:get_value("i1411") == 9 then
    map:start_dialog("crazy_house.accueil_epi_eo_4-9")
  elseif game:get_value("i1411") == 10 then
    map:start_dialog("crazy_house.accueil_epi_eo_8-10")
  end
end

local function accueil_branche2()

  if game:get_value("i1412") == 1 then
    map:start_dialog("crazy_house.accueil_bal_eo_1-6-8-10")
  elseif game:get_value("i1412") == 2 then
    map:start_dialog("crazy_house.accueil_bal_eq_2")
  elseif game:get_value("i1412") == 3 then
    map:start_dialog("crazy_house.accueil_bal_eq_3")
  elseif game:get_value("i1412") == 4 then
    map:start_dialog("crazy_house.accueil_bal_eq_4")
  elseif game:get_value("i1412") == 5 then
    map:start_dialog("crazy_house.accueil_bal_eo_5-9")
  elseif game:get_value("i1412") == 6 then
    map:start_dialog("crazy_house.accueil_bal_eo_1-6-8-10")
  elseif game:get_value("i1412") == 7 then
    map:start_dialog("crazy_house.accueil_bal_eq_7")
  elseif game:get_value("i1412") == 8 then
    map:start_dialog("crazy_house.accueil_bal_eo_1-6-8-10")
  elseif game:get_value("i1412") == 9 then
    map:start_dialog("crazy_house.accueil_bal_eo_5-9")
  elseif game:get_value("i1412") == 10 then
    map:start_dialog("crazy_house.accueil_bal_eo_1-6-8-10")
  end
end

-- Hôtesse d'accueil ------------------------------------------
local function accueil()

  if game:get_value("b120") then
    -- Le joueur a retrouvé ses gants
    map:start_dialog("crazy_house.accueil_fini")
  elseif game:get_value("i1410") == nil then
    map:start_dialog("crazy_house.accueil_ech_eq_0")
    game:set_value("i1410", 1)
  elseif game:get_value("i1410") == 1 then
    map:start_dialog("crazy_house.accueil_ech_eq_1")
  elseif game:get_value("i1410") == 2 then
    map:start_dialog("crazy_house.accueil_ech_eq_2")
    game:set_value("i1410", 3)
  elseif game:get_value("i1410") == 3 then
    map:start_dialog("crazy_house.accueil_ech_eq_3")
  elseif game:get_value("i1410") == 4 then
    map:start_dialog("crazy_house.accueil_ech_eq_4")
  elseif game:get_value("i1410") == 5 then
    map:start_dialog("crazy_house.accueil_ech_eo_5-7")
  elseif game:get_value("i1410") == 6 then
    map:start_dialog("crazy_house.accueil_ech_eq_6")
  elseif game:get_value("i1410") == 7 then
    map:start_dialog("crazy_house.accueil_ech_eo_5-7")
  elseif game:get_value("i1410") == 8 then
    if game:get_value("i1411") < 10 and game:get_value("i1412") < 10 then        	
      if game:get_value("i1411") > game:get_value("i1412") then
        accueil_branche1()
      else
        accueil_branche2()
      end
    else
      if game:get_value("i1411") == 10 then
        accueil_branche2()
      elseif game:get_value("i1412") == 10 then
        accueil_branche1()
      end
    end
  elseif game:get_value("i1410") == 9 then
    map:start_dialog("crazy_house.accueil_ech_eq_9")
  elseif game:get_value("i1410") == 10 then
    map:start_dialog("crazy_house.accueil_ech_eq_10")
  elseif game:get_value("i1410") == 11 then
    map:start_dialog("crazy_house.accueil_ech_eq_11")
  end
end

-- Guichet 11 -------------------------------------------------
local function guichet_11()

  if game:get_value("i1410") >= 8 then
    if game:get_value("i1412") == 9 then
      -- Chercher des haches (mais future erreur : donné : roc magma)
      if game.get_item("tapisserie_counter"):has_amount(1) then
        map:start_dialog("crazy_house.guichet_11_bal_eq_9", function(answer)

          if answer == 0 then
            if game:get_item("tapisserie_counter"):has_amount(1) then
              -- Obtention du roc magma (guichet 11)
              guichet_11_error = true
              hero:start_treasure("roc_magma")
              game:get_item("tapisserie_counter"):remove_amount(1)
              -- Incrémentation branche 1412
              game:set_value("i1412", 10)
            end
          end

        end)
      else        	
        map:start_dialog("crazy_house.guichet_11_ech_eq_9")
      end
    else
      -- Chercher des haches
      if game.get_item("tapisserie_counter"):has_amount(1) then
        map:start_dialog("crazy_house.guichet_11_ech_eq_9_ht", function(answer)

          if answer == 1 then
            if game:get_item("tapisserie_counter"):has_amount(1) then
              -- Obtention de la hache (guichet 11)
              hero:start_treasure("hache")
              game:get_item("tapisserie_counter"):remove_amount(1)
              -- Incrémentation branche 1411
              local branche1411 = game:get_value("i1411")
              if branche1411 > 0 and branche1411 <= 6 then
                game:set_value("i1411", 7)
              end
            end
          end

        end)
      else        	
        map:start_dialog("crazy_house.guichet_11_ech_eq_9")
      end
      -- Incrémentation branche 1411
      local branche1411 = game:get_value("i1411")
      if branche1411 > 0 and branche1411 <= 2 then
        game:set_value("i1411", 3)
      end
    end
  else
    -- S'adresser à l'accueil
    map:start_dialog("crazy_house.guichet_11_ech_ne_9")
  end
  -- Incrémentation branche 1412
  local branche1412 = game:get_value("i1412")
  if branche1412 > 0 and branche1412 <= 5 then
    game:set_value("i1412", 6)
  end
end

-- Guichet 12a ------------------------------------------------
local function guichet_12A()

  if game:get_value("i1410") == 5 then
    map:start_dialog("crazy_house.guichet_12A_ech_eq_5")
    game:set_value("i1410", 6)
  else
    map:start_dialog("crazy_house.guichet_12A_ech_ne_5")
  end
end

-- Guichet 12b -----------------------------------------------
local function guichet_12B()

  if weak_wall_A:is_closed() then -- hint for the first weak wall
    map:start_dialog("crazy_house.guichet_12B_ech_eq_3")
  elseif not game:get_value("b130") then -- hint for the second weak wall
    map:start_dialog("crazy_house.guichet_12B_aw")
  elseif game:get_value("i1410") == 3 then
    map:start_dialog("crazy_house.guichet_12B_ech_eq_3")
  elseif game:get_value("i1410") >= 7 then
    if game:get_value("i1410") == 7 then
      game:set_value("i1410", 8)
      game:set_value("i1411", 1)
      game:set_value("i1412", 1)
    end
    map:start_dialog("crazy_house.guichet_12B_ech_eq_7", function(answer)

      -- Echange pour parfum
      if answer == 1 then
        -- Contrôle de quantité bocal d'épices et balai
        if game:get_item("bocal_epice_counter"):has_amount(1)
            and game:get_item("balai_counter"):has_amount(1) then
          map:start_dialog("crazy_house.guichet_12B_ech_eq_7_ok", function()

            -- Obtention du parfum (guichet 12B)
            hero:start_treasure("parfum")
            game:get_item("bocal_epice_counter"):remove_amount(1)
            game:get_item("balai_counter"):remove_amount(1)
            game:set_value("i1410", 10)

          end)
        else
          if game:get_item("bocal_epice_counter"):has_amount(1) then
            map:start_dialog("crazy_house.guichet_12B_ech_eq_7_un_balai")
          elseif game:get_item("balai_counter"):has_amount(1) then
            map:start_dialog("crazy_house.guichet_12B_ech_eq_7_un_bocal")
          else
            map:start_dialog("crazy_house.guichet_12B_ech_eq_7_un")
          end
        end
      else
        map:start_dialog("crazy_house.guichet_12B_ech_eq_7_no")
      end

    end)
  else
    map:start_dialog("crazy_house.guichet_12B_aw")
  end
end

-- Tableau de mario qui parle ---------------------------------
function mario_message_1:on_interaction()
  sol.audio.play_sound("sm64_memario")
  map:start_dialog("crazy_house.mario_message_1")
end

function AccueilFront:on_interaction()
  accueil()
end

function GC11Front:on_interaction()
  guichet_11()
end

function GC12A:on_interaction()
  guichet_12A()
end

function GC12B:on_interaction()
  guichet_12B()
end

function Accueil:on_interaction()
  accueil()
end

function GC11:on_interaction()
  guichet_11()
end

function GC12A:on_interaction()
  guichet_12A()
end

function GC12B:on_interaction()
  guichet_12B()
end

-- Fonctionnaire en grève
function passage_sensor_A:on_activated()

  if not map:get_crystal_state() then
    map:start_dialog("crazy_house.public_agent")
  end
end

function weak_wall_A:on_opened()
  sol.audio.play_sound("secret")
end

function DK1:on_opened()
  -- Opening the locked door: never give the final small key
  game:set_value("b128", true)
end

function CK3:on_empty()
  if game:get_value("b141") then
    -- The locked door in 3F is already open
    hero:start_treasure("rupee", 4)
  else
    -- Normal case: give a small key
    hero:start_treasure("small_key")
  end
end

function map:on_obtained_treasure(item_name, variant, savegame_variable)

  if item_name == "roc_magma" and guichet_11_error then
    map:start_dialog("crazy_house.guichet_11_bal_err")
  end
end

