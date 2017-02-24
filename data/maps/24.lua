local map = ...
local game = map:get_game()

----------------------------------
-- Crazy House 3F               --
----------------------------------

local giga_bouton_pushed = false
local dialogue_trop_leger_fait = false

function map:on_started(destination_point)

  -- Desactivation des sensors pour la porte du couloir sans fin
  bowser_leave:set_enabled(false)
  bowser_exit:set_enabled(false)

  -- Boutons sauvegardés
  if game:get_value("b126") then
    infinite_corridor:set_enabled(false)
    giga_bouton:set_activated(true)
  end

  if game:get_value("b129") then
    map:set_entities_enabled("barrier_tile", false)
    barrier_switch:set_activated(true)
  end
end

function map:on_opening_transition_finished(destination_point)

  -- Affichage du nom du donjon quand on vient de l'escalier de dehors
  if destination_point == fromOutsideSO then
    game:start_dialog("crazy_house.title")
  end
end

-- Guichet 31 -------------------------------------------------
local function guichet_31()

  game:start_dialog("crazy_house.guichet_31")
end

-- Guichet 32 -------------------------------------------------
local function guichet_32()

  if game:get_value("i1410") == 6 then
    game:start_dialog("crazy_house.guichet_32_ech_le_6")
    game:set_value("i1410", 7)
  else
    game:start_dialog("crazy_house.guichet_32_ech_ne_6", function(answer)

      -- Echange de hache contre cuillere
      if answer == 1 then
        if game:get_item("hache_counter"):has_amount(1) then
          hero:start_treasure("cuillere")
          game:get_item("hache_counter"):remove_amount(1)
        else
          sol.audio.play_sound("wrong")
          game:start_dialog("crazy_house.guichet_32_ech_ne_6_un")
        end
      else
        game:start_dialog("crazy_house.guichet_32_ech_ne_6_no")
      end

    end)
  end
  -- Incrémentation branche 1412
  local branche1412 = game:get_value("i1412") or 0
  if branche1412 > 0 and branche1412 <= 4 then
    game:set_value("i1412", 5)
  end
end

-- Guichet 33 -------------------------------------------------
local function guichet_33()

  local small_key_obtained = game:get_value("b123")
  local branche1410 = game:get_value("i1410") or 0
  if branche1410 == 3
      and not small_key_obtained then
    game:start_dialog("crazy_house.guichet_33_ech_eq_3")
  elseif branche1410 >= 4
      and not small_key_obtained then
    if game:get_item("parfum_counter"):has_amount(1) then
      -- A le parfum
      game:start_dialog("crazy_house.guichet_33_parfum", function()

        -- Obtention clé du guichet 33 suite à l'apport du parfum
        if game:get_item("parfum_counter"):has_amount(1) then
          hero:start_treasure("small_key", 1, "b123")
          game:get_item("parfum_counter"):remove_amount(1)
        end

      end)
    else
      -- N'a pas encore le parfum
      game:start_dialog("crazy_house.guichet_33_ech_ge_4")
      if branche1410 == 4 then
        game:set_value("i1410", 5)
      end
    end
  else
    game:start_dialog("crazy_house.guichet_33_ech_le_2")
  end
end

-- Apothicaire ------------------------------------------------
local function apothicaire()

  game:start_dialog("crazy_house.apothicaire", function(answer)

    -- Achat de sacs de riz à l'apothicaire        	
    if answer == 1 then
      if game:get_money() >= 20 then
        game:start_dialog("crazy_house.apothicaire_oui", function()

          -- Remise du sac de riz achetés à l'apothicaire
          hero:start_treasure("sac_riz")

        end)
        game:remove_money(20)

        -- Incrémentation branche 1411
        local branche1411 = game:get_value("i1411")
        if branche1411 == 4 then
          game:set_value("i1411", 5)
        end

        -- Incrémentation branche 1412
        local branche1412 = game:get_value("i1412") or 0
        if branche1412 >= 6 and branche1412 <= 7 then
          game:set_value("i1412", 8)
        end
      else
        sol.audio.play_sound("wrong")
        game:start_dialog("crazy_house.apothicaire_rubis")
      end
    else
      game:start_dialog("crazy_house.apothicaire_non")
    end

  end)
end

-- Guichet 36 -------------------------------------------------
local function guichet_36()

  game:start_dialog("crazy_house.guichet_36", function(answer)

    -- Achat de 3 sacs de riz à Panoda Fichage
    if answer == 1 then
      if game:get_money() >= 50 then
        game:remove_money(50)
        hero:start_treasure("sac_riz")
        game:get_item("sac_riz_counter"):add_amount(2)
        -- Incrémentation branche 1411
        local branche1411 = game:get_value("i1411")
        if branche1411 == 4 then
          game:set_value("i1411", 5)
        end
        -- Incrémentation branche 1412
        local branche1412 = game:get_value("i1412") or 0
        if branche1412 >= 6 and branche1412 <= 7 then
          game:set_value("i1412", 8)
        end
      else
        sol.audio.play_sound("wrong")
        game:start_dialog("crazy_house.guichet_36_un")
      end
    end

  end)
end

function GC33:on_interaction()
  guichet_33()
end

function Apothicaire:on_interaction()
  apothicaire()
end

function GC31:on_interaction()
  guichet_31()
end

function GC32:on_interaction()
  guichet_32()
end

function GC33Front:on_interaction()
  GC33:get_sprite():set_direction(3)
  guichet_33()
end

function GC36:on_interaction()
  guichet_36()
end

function Apothicaire:on_interaction()
  apothicaire()
end

-- Link approche de la porte qui annonce le couloir sans fin
function bowser_message:on_activated()

  if not game:get_value("b126") then
    -- Bouton pas appuyé
    bowser_close:set_enabled(true)
    if bowser_door:is_closed() then
      game:start_dialog("crazy_house.infinite_greetings", function()

        -- Ouverture de la porte vers le couloir sans fin
        if bowser_door:is_closed() then
          map:open_doors("bowser_door")
        end
        bowser_leave:set_enabled(true)

      end)
      sol.audio.play_sound("sm64_bowser_message")
    else
      bowser_leave:set_enabled(true)
    end
  else
    -- Bouton déjà appuyé
    if bowser_door:is_closed() then
      map:open_doors("bowser_door")
    end
    bowser_leave:set_enabled(true)
  end
end

-- Fermeture de la porte derrière Link après être entré
function bowser_close:on_activated()

  if bowser_door:is_open() then
    map:close_doors("bowser_door")
  end
  bowser_exit:set_enabled(true)
  bowser_close:set_enabled(false)
end

-- Ouverture de la porte si Link souhaite sortir
function bowser_exit:on_activated()

  if bowser_door:is_closed() then
    map:open_doors("bowser_door")
  end
  bowser_message:set_enabled(false)
  bowser_close:set_enabled(true)
  bowser_exit:set_enabled(false)
end

-- Fermeture de la porte derrière Link après être sorti
function bowser_leave:on_activated()

  if bowser_door:is_open() then
    map:close_doors("bowser_door")
  end
  bowser_message:set_enabled(true)
  bowser_leave:set_enabled(false)
end

-- Mécanisme du couloir sans fin
function infinite_corridor:on_activated()
  hero:set_position(1136, 797, 1)
end

-- Giga bouton : Link trop léger
function giga_bouton_sensor:on_activated()

  if not dialogue_trop_leger_fait
      and not giga_bouton:is_activated() then
    game:start_dialog("crazy_house.giga_bouton_trop_leger")
    dialogue_trop_leger_fait = true
  end
end

-- Appui sur le giga bouton d'extra collision à charge supérieure de
-- 15.000 megawatts
function GBS:on_moved()

  if not giga_bouton_pushed then
    local x, y = self:get_position()
    if x == 1664 and y == 797 then
      giga_bouton_pushed = true
      giga_bouton:set_activated(true)
      infinite_corridor:set_enabled(false)
      game:set_value("b126", true)
      map:move_camera(888, 792, 250, function()
        sol.audio.play_sound("secret")
      end)
      infinite_corridor:set_enabled(false)
    end
  end
end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if item:get_name() == "glove" then
    -- Fin du donjon
    hero:start_victory(function()
      sol.audio.play_sound("warp")
      hero:teleport("3", "from_crazy_house")
    end)
  end
end

-- Ouverture de la barrière près du giga bouton d'extra collision à charge supérieure de 15.000 megawatts
function barrier_switch:on_activated()
  sol.audio.play_sound("secret")
  map:set_entities_enabled("barrier_tile", false)
  game:set_value("b129", true)
end

local function storage_room_chest_empty()
  sol.audio.play_sound("wrong")
  game:start_dialog("_empty_chest")
  hero:unfreeze()
end

for chest in map:get_entities("storage_room_empty_chest") do
  chest.on_opened = storage_room_chest_empty
end

