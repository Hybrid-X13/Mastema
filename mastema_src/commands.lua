local SaveData = require("mastema_src.savedata")

local Commands = {}

function Commands.executeCMD(cmd)
	local string = string.lower(cmd)
	
	if string == "mastemahelp" then
		print("Mastema Commands:")
		print("mastemamarks: Check progress for Mastema's completion marks")
		print("tmastemamarks: Check progress for Tainted Mastema's completion marks")
		print("mastemaunlockall: Unlocks all items for both characters")
		print("mastemareset: Resets item progress for both characters")
	elseif string == "mastemamarks"
	or cmd == "tmastemamarks"
	then
		local completionCount = 0
		local boss = {
			Isaac = "Isaac          : ",
			BlueBaby = "Blue Baby      : ",
			Satan = "Satan          : ",
			TheLamb = "The Lamb       : ",
			BossRush = "Boss Rush      : ",
			Hush = "Hush           : ",
			MegaSatan = "Mega Satan     : ",
			Delirium = "Delirium       : ",
			Mother = "Mother         : ",
			Beast = "The Beast      : ",
			Greed = "Greed Mode     : ",
			Greedier = "Greedier       : ",
			FullCompletion = "Full Completion: ",
		}
		local completion = {
			Isaac = "Unlocked Eternal Card",
			BlueBaby = "Unlocked Book of Jubilees",
			Satan = "Unlocked Life Savings",
			TheLamb = "Unlocked Bloody Harvest",
			BossRush = "Unlocked Mastema's Wrath",
			Hush = "Unlocked Life Dice",
			MegaSatan = "Unlocked Twisted Faith",
			Delirium = "Unlocked Torn Wings",
			Mother = "Unlocked Raven Beak",
			Beast = "Unlocked Bloodsplosion",
			Greed = "Unlocked Mantled Heart",
			Greedier = "Unlocked Devil's Bargain",
			FullCompletion = "Unlocked Purist's Heart",
		}
		local completionB = {
			Isaac = "Unlocked Goodwill Tag",
			BlueBaby = "Unlocked Prayer of Repentance",
			Satan = "Unlocked Shattered Soul",
			TheLamb = "Unlocked Sanguine Jewel",
			BossRush = "Unlocked Broken Dice",
			Hush = "Unlocked Soul of Mastema",
			MegaSatan = "Unlocked Satanic Rituals",
			Delirium = "Unlocked Sinister Sight",
			Mother = "Unlocked Sacrificial Chalice",
			Beast = "Unlocked Corrupt Heart",
			Greed = "Unlocked Satanic Charm",
			Greedier = "Unlocked Unholy Card",
			FullCompletion = "Unlocked Spirit's Heart",
		}
		
		if string == "mastemamarks" then
			print("mastema Completion Mark Progress:")

			for key, val in pairs(SaveData.UnlockData.Mastema) do
				if not val then
					completion[key] = "???"
				end
				if completion[key] ~= "???" then
					completionCount = completionCount + 1
				end
				print(boss[key] .. completion[key])
			end
	
			if completionCount < 12 then
				completion.FullCompletion = "???"
			end
			print(boss.FullCompletion .. completion.FullCompletion)
		elseif string == "tmastemamarks" then
			print("Tainted mastema Completion Mark Progress:")

			for key, val in pairs(SaveData.UnlockData.T_Mastema) do
				if not val then
					completionB[key] = "???"
				end
				if completionB[key] ~= "???" then
					completionCount = completionCount + 1
				end
				print(boss[key] .. completionB[key])
			end
	
			if completionCount < 12 then
				completionB.FullCompletion = "???"
			end
			print(boss.FullCompletion .. completionB.FullCompletion)
		end
	elseif string == "mastemaunlockall" then
		for key, val in pairs(SaveData.UnlockData.Mastema) do
			if not val then
				SaveData.UnlockData.Mastema[key] = true
			end
		end
		for key, val in pairs(SaveData.UnlockData.T_Mastema) do
			if not val then
				SaveData.UnlockData.T_Mastema[key] = true
			end
		end
		SaveData.SaveModData()
		print("Hope you enjoy the items... cheater")
	elseif string == "mastemareset" then
		for key, val in pairs(SaveData.UnlockData.Mastema) do
			if val then
				SaveData.UnlockData.Mastema[key] = false
			end
		end
		for key, val in pairs(SaveData.UnlockData.T_Mastema) do
			if val then
				SaveData.UnlockData.T_Mastema[key] = false
			end
		end
		SaveData.SaveModData()
		print("Completion mark progress for both characters has been reset")
	end
end

return Commands