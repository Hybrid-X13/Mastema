local Mastema = require("mastema_src.characters.mastema")
local T_Mastema = require("mastema_src.characters.t_mastema")
local MantledHeart = require("mastema_src.items.trinkets.mantled_heart")
local ShatteredSoul = require("mastema_src.items.trinkets.shattered_soul")
local SatanicCharm = require("mastema_src.items.trinkets.satanic_charm")

local function MC_PRE_PICKUP_COLLISION(_, entity, collider, low)
	local returned = Mastema.prePickupCollision(entity, collider, low)
	if returned ~= nil then return returned end

	local returned = T_Mastema.prePickupCollision(entity, collider, low)
	if returned ~= nil then return returned end

	local returned = MantledHeart.prePickupCollision(entity, collider, low)
	if returned ~= nil then return returned end

	local returned = ShatteredSoul.prePickupCollision(entity, collider, low)
	if returned ~= nil then return returned end

	local returned = SatanicCharm.prePickupCollision(entity, collider, low)
	if returned ~= nil then return returned end
end

return MC_PRE_PICKUP_COLLISION