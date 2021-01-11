local mod	= DBM:NewMod("Darkmaster", "DBM-Party-Vanilla", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(1853)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"PLAYER_ALIVE"
)




