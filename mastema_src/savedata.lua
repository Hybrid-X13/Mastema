local mod = MASTEMA
local json = require("json")
local game = Game()

local SaveData = {}
local SAVE_STATE = {}

SaveData.UnlockData ={
	Mastema = {
		Isaac = false,
		BlueBaby = false,
		Satan = false,
		TheLamb = false,
		BossRush = false,
		Hush = false,
		MegaSatan = false,
		Delirium = false,
		Mother = false,
		Beast = false,
		Greed = false,
		Greedier = false,
	},
	T_Mastema ={
		Isaac = false,
		BlueBaby = false,
		Satan = false,
		TheLamb = false,
		BossRush = false,
		Hush = false,
		MegaSatan = false,
		Delirium = false,
		Mother = false,
		Beast = false,
		Greed = false,
		Greedier = false,
	},
}

SaveData.PlayerData = {
	Mastema = {
		Birthright = {
			DMG = 0,
			Tears = 0,
			Speed = 0,
			Range = 0,
			Luck = 0,
		},
		BlindItem = 0,
	},
	T_Mastema = {
		
	},
}

SaveData.ItemData = {
	BookOfJubilees = {
		Count = 0,
		Count7x7 = 0,
		Count7x7x7 = 0,
	},
	RavenBeak = {
		DMG = 0,
	},
	DevilsBargain = {
		BargainItem = 0,
		RedHearts = 0,
		SoulHearts = 0,
		IsCharging = false,
		Reset = true,
	},
	SacrificialChalice = {
		Level = 0,
		Hits = 0,
	},
	SatanicCharm = {
		DMG = 0,
	},
	ShatteredSoul = {
		BrokenItem = 0,
		DealItems = {},
	},
	SatanicRitual = {
		DMG = 0,
		Tears = 0,
		Speed = 0,
		Luck = 0,
		Level = 1,
	},
}

function SaveData.SaveModData()
	SAVE_STATE.UnlockData = SaveData.UnlockData
	SAVE_STATE.PlayerData = SaveData.PlayerData
	SAVE_STATE.ItemData = SaveData.ItemData

	mod:SaveData(json.encode(SAVE_STATE))
end

function SaveData.postPlayerInit(player)
	if mod:HasData() then
		SAVE_STATE = json.decode(mod:LoadData())

		--Cleanse my old sins
		if SAVE_STATE.UnlockData == nil
		and type(SAVE_STATE[1]) == "table"
		then
			local copy1 = SAVE_STATE[1]
			local copy2 = SAVE_STATE[2]
			local oldData1 = {
				Isaac = copy1[1],
				BlueBaby = copy1[2],
				Satan = copy1[3],
				TheLamb = copy1[4],
				BossRush = copy1[5],
				Hush = copy1[6],
				MegaSatan = copy1[7],
				Delirium = copy1[8],
				Mother = copy1[9],
				Beast = copy1[10],
				Greed = copy1[11],
				Greedier = copy1[12],
			}
			local oldData2 = {
				Isaac = copy2[1],
				BlueBaby = copy2[2],
				Satan = copy2[3],
				TheLamb = copy2[4],
				BossRush = copy2[5],
				Hush = copy2[6],
				MegaSatan = copy2[7],
				Delirium = copy2[8],
				Mother = copy2[9],
				Beast = copy2[10],
				Greed = copy2[11],
				Greedier = copy2[12],
			}

			for key, val in pairs(oldData1) do
				if oldData1[key] == 1 then
					SaveData.UnlockData.Mastema[key] = true
				end
			end

			for key, val in pairs(oldData2) do
				if oldData2[key] == 1 then
					SaveData.UnlockData.T_Mastema[key] = true
				end
			end
			
			SAVE_STATE.UnlockData = SaveData.UnlockData
		else
			SaveData.UnlockData.Mastema = SAVE_STATE.UnlockData.Mastema
			SaveData.UnlockData.T_Mastema = SAVE_STATE.UnlockData.T_Mastema
		end

		if game:GetFrameCount() == 0 then
			SaveData.PlayerData = {
				Mastema = {
					Birthright = {
						DMG = 0,
						Tears = 0,
						Speed = 0,
						Range = 0,
						Luck = 0,
					},
					BlindItem = 0,
				},
				T_Mastema = {
					
				},
			}
			
			SaveData.ItemData = {
				BookOfJubilees = {
					Count = 0,
					Count7x7 = 0,
					Count7x7x7 = 0,
				},
				RavenBeak = {
					DMG = 0,
				},
				DevilsBargain = {
					BargainItem = 0,
					RedHearts = 0,
					SoulHearts = 0,
					IsCharging = false,
					Reset = true,
				},
				SacrificialChalice = {
					Level = 0,
					Hits = 0,
				},
				SatanicCharm = {
					DMG = 0,
				},
				ShatteredSoul = {
					BrokenItem = 0,
					DealItems = {},
				},
				SatanicRitual = {
					DMG = 0,
					Tears = 0,
					Speed = 0,
					Luck = 0,
					Level = 1,
				},
			}

			player:AddCacheFlags(CacheFlag.CACHE_ALL)
			SaveData.SaveModData()
		else
			SaveData.PlayerData.Mastema = SAVE_STATE.PlayerData.Mastema
			SaveData.PlayerData.T_Mastema = SAVE_STATE.PlayerData.T_Mastema
			SaveData.ItemData = SAVE_STATE.ItemData
		end
	end
end

function SaveData.postNewLevel()
	SaveData.SaveModData()
end

function SaveData.preGameExit()
	SaveData.PlayerData.Mastema.BlindItem = 0
	SaveData.ItemData.ShatteredSoul.BrokenItem = 0
	SaveData.SaveModData()
end

return SaveData