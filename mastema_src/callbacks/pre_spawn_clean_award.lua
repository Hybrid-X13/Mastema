local BookOfJubilees = require("mastema_src.items.passives.book_of_jubilees")

local function MC_PRE_SPAWN_CLEAN_AWARD()
	BookOfJubilees.preSpawnCleanAward()
end

return MC_PRE_SPAWN_CLEAN_AWARD