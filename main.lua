--[[
    Shoutout to AgentCucco for making the Job Mod: https://steamcommunity.com/sharedfiles/filedetails/?id=2567634705
    All of Mastema's code was completely restructured and revised to follow Job's structuring. 
    Check out Job if you haven't already, it's one of the best character mods out there.
]]

if not REPENTANCE then return end

print("[Mastema] Type `mastemahelp` for a list of commands")

MASTEMA = RegisterMod("Mastema", 1)
local mod = MASTEMA

--Callbacks
local postPEffectUpdate = require("mastema_src.callbacks.post_peffect_update")
local preUseItem = require("mastema_src.callbacks.pre_use_item")
local useItem = require("mastema_src.callbacks.use_item")
local useCard = require("mastema_src.callbacks.use_card")
local familiarInit = require("mastema_src.callbacks.familiar_init")
local familiarUpdate = require("mastema_src.callbacks.familiar_update")
local evaluateCache = require("mastema_src.callbacks.evaluate_cache")
local postPlayerInit = require("mastema_src.callbacks.post_player_init")
local preGameExit = require("mastema_src.callbacks.pre_game_exit")
local entityTakeDmg = require("mastema_src.callbacks.entity_take_dmg")
local postNewLevel = require("mastema_src.callbacks.post_new_level")
local postNewRoom = require("mastema_src.callbacks.post_new_room")
local preSpawnCleanAward = require("mastema_src.callbacks.pre_spawn_clean_award")
local postEntityKill = require("mastema_src.callbacks.post_entity_kill")
local postNPCDeath = require("mastema_src.callbacks.post_npc_death")
local postPlayerUpdate = require("mastema_src.callbacks.post_player_update")
local preGetCollectible = require("mastema_src.callbacks.pre_get_collectible")
local postPickupInit = require("mastema_src.callbacks.post_pickup_init")
local postPickupUpdate = require("mastema_src.callbacks.post_pickup_update")
local prePickupCollision = require("mastema_src.callbacks.pre_pickup_collision")
local postFireTear = require("mastema_src.callbacks.post_fire_tear")
local postTearUpdate = require("mastema_src.callbacks.post_tear_update")
local postLaserUpdate = require("mastema_src.callbacks.post_laser_update")
local postEffectInit = require("mastema_src.callbacks.post_effect_init")
local postEffectUpdate = require("mastema_src.callbacks.post_effect_update")
local postRender = require("mastema_src.callbacks.post_render")
local executeCMD = require("mastema_src.callbacks.execute_cmd")

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, postPEffectUpdate)
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, preUseItem)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, useItem)
mod:AddCallback(ModCallbacks.MC_USE_CARD, useCard)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, familiarInit)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, familiarUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, postPlayerInit)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, entityTakeDmg)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, preGameExit)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, postNewLevel)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, postNewRoom)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, preSpawnCleanAward)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, postEntityKill)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, postNPCDeath)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, postPlayerUpdate)
mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, preGetCollectible)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, postPickupInit)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, postPickupUpdate)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, prePickupCollision)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, postFireTear)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, postTearUpdate)
mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, postLaserUpdate)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, postEffectInit)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, postEffectUpdate)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, postRender)
mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, executeCMD)

--Mod Compat
require("mastema_src.compat.eid")
require("mastema_src.compat.encyclopedia")
require("mastema_src.compat.pog")