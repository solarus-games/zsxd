local map = ...

----------------------------------
-- Crazy House 1FB (north)      --
----------------------------------

local guichet43_sprite

function map:on_started(destination_point)

  guichet43_sprite = sol.map.npc_get_sprite("GC43S")
end

-- Guichet 41 -------------------------------------------------
function guichet_41()

  if game:get_value("i1410") == 3 then
    map:start_dialog("crazy_house.guichet_41_ech_eq_3")
    game:set_value("i1410", 4)
  else
    map:start_dialog("crazy_house.guichet_41_ech_ne_3")
  end
end

-- Guichet 43 -------------------------------------------------
function guichet_43()

  map:start_dialog("crazy_house.guichet_43")
end

-- Guichet 45 -------------------------------------------------
function guichet_45()

  if game:get_value("i1410") == 3 then
    map:start_dialog("crazy_house.guichet_45_ech_eq_3")
  else
    map:start_dialog("crazy_house.guichet_45_ech_ne_3")
  end

  -- Incrémentation branche 1412
  local branche1412 = game:get_value("i1412")
  if branche1412 > 0 and branche1412 <= 3 then
    game:set_value("i1412", 4)
  end
end

-- Guichet 47 -------------------------------------------------
function guichet_47()

  if game:get_value("i1410") == 3 then
    map:start_dialog("crazy_house.guichet_47_ech_eq_3")
  else
    map:start_dialog("crazy_house.guichet_47_ech_ne_3")
  end
end

-- Guichet 49 -------------------------------------------------
function guichet_49()

  map:start_dialog("crazy_house.guichet_49")
end

function map:on_npc_interaction(npc_name)

  if npc_name == "mario_message_2" then
    -- Tableau de mario qui parle ---------------------------------
    sol.audio.play_sound("sm64_heehee")
  elseif npc_name == "GC41" then
    guichet_41()
  elseif npc_name == "GC43" then
    guichet_43()
  elseif npc_name == "GC45" then
    guichet_45()
  elseif npc_name == "GC47" then
    guichet_47()
  elseif npc_name == "GC49" then
    guichet_49()
  end
end

function map:on_dialog_finished(dialog_id, answer)

  if dialog_id == "crazy_house.guichet_43" then
    -- Pipelette (guichet 43) qui se tourne vers Link, énervée
    guichet43_sprite:set_direction(3)
    map:start_dialog("crazy_house.guichet_43n")
  elseif dialog_id == "crazy_house.guichet_43n" then
    -- Pipelette reprend sa conversation
    guichet43_sprite:set_direction(2)
    map:start_dialog("crazy_house.guichet_43f")
  elseif dialog_id == "crazy_house.guichet_45_ech_ne_3" then
    if answer == 0 then
      if sol.game.get_item_amount("cuillere_counter") >= 1 then
        map:start_dialog("crazy_house.guichet_45_ech_ok")
      else
        sol.audio.play_sound("wrong")
        map:start_dialog("crazy_house.guichet_45_ech_un")
      end
    end
  elseif dialog_id == "crazy_house.guichet_45_ech_ok" then
    sol.map.treasure_give("sac_olive", 1, -1)
    sol.game.remove_item_amount("cuillere_counter", 1)
  end
end

