local T_Mastema = require("mastema_src.characters.t_mastema")
local DevilsBargain = require("mastema_src.items.actives.devils_bargain")
local SacrificialChalice = require("mastema_src.items.familiars.sacrificial_chalice")
local SinisterSight = require("mastema_src.items.passives.sinister_sight")
local LifeSavings = require("mastema_src.items.trinkets.life_savings")
local ShatteredSoul = require("mastema_src.items.trinkets.shattered_soul")

local function MC_ENTITY_TAKE_DMG(_, entity, amount, flags, source, countdown)
	local returned = T_Mastema.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end
	
	local returned = DevilsBargain.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end

	local returned = LifeSavings.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end

	local returned = SacrificialChalice.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end

	local returned = SinisterSight.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end

	local returned = ShatteredSoul.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end
end

return MC_ENTITY_TAKE_DMG