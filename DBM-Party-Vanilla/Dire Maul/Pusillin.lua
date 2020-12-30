local mod	= DBM:NewMod("Pusillin", "DBM-Party-Vanilla", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(14354)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"PLAYER_ALIVE"
)




