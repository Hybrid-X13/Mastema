if Poglite then
	local Enums = require("mastema_src.enums")

	local playerType = Enums.Characters.MASTEMA
	local pogCostume = Isaac.GetCostumeIdByPath("gfx/characters/mastemapog.anm2")
	Poglite:AddPogCostume("MastemaPog", playerType, pogCostume)
	
	local playerTypeB = Enums.Characters.T_MASTEMA
	local pogCostumeB = Isaac.GetCostumeIdByPath("gfx/characters/mastemabpog.anm2")
	Poglite:AddPogCostume("MastemaBPog", playerTypeB, pogCostumeB)
end