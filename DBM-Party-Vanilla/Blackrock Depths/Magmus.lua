local mod	= DBM:NewMod("Magmus", "DBM-Party-Vanilla", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(9938)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"PLAYER_ALIVE"
)




