local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local game = Game()

local Trinket = {}

function Trinket.postNewRoom()
	local room = game:GetRoom()

	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if not player:HasTrinket(Enums.Trinkets.GOODWILL_TAG) then return end
		if not room:IsFirstVisit() then return end

		local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.GOODWILL_TAG)
		
		if room:GetType() == RoomType.ROOM_ANGEL then
			Isaac.ExecuteCommand("spawn beggar")
		elseif room:GetType() == RoomType.ROOM_DEVIL then
			local spawnpos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0)

			if Functions.AnyPlayerIsType(Enums.Characters.MASTEMA)
			or Functions.AnyPlayerIsType(Enums.Characters.T_MASTEMA)
			then
				spawnpos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
			end

			Isaac.Spawn(EntityType.ENTITY_SLOT, 5, 0, spawnpos, Vector.Zero, nil)
		elseif room:GetType() == RoomType.ROOM_TREASURE then
			Isaac.ExecuteCommand("spawn key master")
		elseif room:GetType() == RoomType.ROOM_PLANETARIUM then
			Isaac.ExecuteCommand("spawn wisp wizard")
		elseif room:GetType() == RoomType.ROOM_SHOP
		and trinketMultiplier > 1
		then
			Isaac.ExecuteCommand("spawn battery bum")
		elseif room:GetType() == RoomType.ROOM_SECRET
		and trinketMultiplier > 2
		then
			Isaac.ExecuteCommand("spawn bomb bum")
		end
	end
end

return Trinket