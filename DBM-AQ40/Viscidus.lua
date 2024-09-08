local mod	= DBM:NewMod("Viscidus", "DBM-AQ40", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(15299)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"PLAYER_ALIVE"
)



local berserkTimer	=	mod:NewBerserkTimer(420)

function mod:OnCombatStart(delay)
	berserkTimer:Start()	
end