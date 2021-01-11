local mod	= DBM:NewMod("Immolthar", "DBM-Party-Vanilla", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(11496)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"PLAYER_ALIVE"
)




