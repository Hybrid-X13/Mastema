local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local birthcakeAdded = false

local BirthcakeCompat = {}

function BirthcakeCompat.postGameStarted(isContinue)
    if Birthcake
    and not birthcakeAdded
    then
        Birthcake.BirthcakeDescs[Enums.Characters.MASTEMA] = "Temptation up"
        Birthcake.BirthcakeDescs[Enums.Characters.T_MASTEMA] = "Mend your sins"
    
        Birthcake.TrinketDesc[Enums.Characters.MASTEMA] = {Normal = "An extra pickup surrounded by spikes spawns in shops, treasure, devil, and angel rooms"}
        Birthcake.TrinketDesc[Enums.Characters.T_MASTEMA] = {Normal = "{{BrokenHeart}} An additional broken heart is removed at the start of each floor"}

        birthcakeAdded = true
    end
end

function BirthcakeCompat.postPickupInit(pickup)
    if Birthcake == nil then return end
    if pickup.Variant ~= PickupVariant.PICKUP_TRINKET then return end

    local birthcakeID = Isaac.GetTrinketIdByName("Birthcake")
    local goldenBirthcake = birthcakeID + TrinketType.TRINKET_GOLDEN_FLAG

    if pickup.SubType ~= birthcakeID and pickup.SubType ~= birthcakeID + TrinketType.TRINKET_GOLDEN_FLAG then return end

    if Functions.AnyPlayerIsType(Enums.Characters.T_MASTEMA) then
        if pickup.SubType == goldenBirthcake then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Enums.Trinkets.T_MASTEMA_BIRTHCAKE + TrinketType.TRINKET_GOLDEN_FLAG, true, false, false)
        elseif pickup.SubType == birthcakeID then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Enums.Trinkets.T_MASTEMA_BIRTHCAKE, true, false, false)
        end
    elseif Functions.AnyPlayerIsType(Enums.Characters.MASTEMA) then
        if pickup.SubType == goldenBirthcake then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Enums.Trinkets.MASTEMA_BIRTHCAKE + TrinketType.TRINKET_GOLDEN_FLAG, true, false, false)
        elseif pickup.SubType == birthcakeID then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Enums.Trinkets.MASTEMA_BIRTHCAKE, true, false, false)
        end
    end
end

function BirthcakeCompat.postPlayerUpdate(player)
    if Birthcake == nil then return end

    local birthcakeID = Isaac.GetTrinketIdByName("Birthcake")
    local goldenBirthcake = birthcakeID + TrinketType.TRINKET_GOLDEN_FLAG
   
    if player:HasTrinket(birthcakeID) then
        if player:GetPlayerType() == Enums.Characters.MASTEMA then
            player:TryRemoveTrinket(birthcakeID)
            player:TryRemoveTrinket(goldenBirthcake)
            player:AddTrinket(Enums.Trinkets.MASTEMA_BIRTHCAKE)
        elseif player:GetPlayerType() == Enums.Characters.T_MASTEMA then
            player:TryRemoveTrinket(birthcakeID)
            player:TryRemoveTrinket(goldenBirthcake)
            player:AddTrinket(Enums.Trinkets.T_MASTEMA_BIRTHCAKE)
        end
    end
end

return BirthcakeCompat