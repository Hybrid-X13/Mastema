local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local game = Game()
local WISP_WZARD = 84

local Trinket = {}

function Trinket.postNewRoom()
	local room = game:GetRoom()

	if not room:IsFirstVisit() then return end

	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasTrinket(Enums.Trinkets.GOODWILL_TAG) then
			local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.GOODWILL_TAG)
			local pos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0)
			
			if room:GetType() == RoomType.ROOM_ANGEL then
				Isaac.Spawn(EntityType.ENTITY_SLOT, Enums.Slots.BEGGAR, 0, pos, Vector.Zero, nil)
			elseif room:GetType() == RoomType.ROOM_DEVIL then
				if Functions.AnyPlayerIsType(Enums.Characters.MASTEMA)
				or Functions.AnyPlayerIsType(Enums.Characters.T_MASTEMA)
				then
					pos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				end

				Isaac.Spawn(EntityType.ENTITY_SLOT, Enums.Slots.DEVIL_BEGGAR, 0, pos, Vector.Zero, nil)
			elseif room:GetType() == RoomType.ROOM_TREASURE then
				Isaac.Spawn(EntityType.ENTITY_SLOT, Enums.Slots.KEY_MASTER, 0, pos, Vector.Zero, nil)
			elseif room:GetType() == RoomType.ROOM_PLANETARIUM
			and ANDROMEDA
			then
				Isaac.Spawn(EntityType.ENTITY_SLOT, WISP_WZARD, 0, pos, Vector.Zero, nil)
			elseif room:GetType() == RoomType.ROOM_SHOP
			and trinketMultiplier > 1
			then
				Isaac.Spawn(EntityType.ENTITY_SLOT, Enums.Slots.BATTERY_BUM, 0, pos, Vector.Zero, nil)
			elseif room:GetType() == RoomType.ROOM_SECRET
			and trinketMultiplier > 2
			then
				Isaac.Spawn(EntityType.ENTITY_SLOT, Enums.Slots.BOMB_BUM, 0, pos, Vector.Zero, nil)
			end
		end
	end
end

return Trinket