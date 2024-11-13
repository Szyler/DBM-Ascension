local mod	= DBM:NewMod(424, "DBM-Party-Vanilla", 8, 232)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(12258)

mod:RegisterCombat("combat")

--Nothing to see here, puncture seems to be randomly cast, and not that important

