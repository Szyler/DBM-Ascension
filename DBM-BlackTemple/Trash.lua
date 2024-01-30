local mod	= DBM:NewMod("Trash", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(22879)
mod:RegisterCombat("combat", 22879)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED"
)

local warningIgnorePain			= mod:NewSpellAnnounce(2142343, 3)
local timerIgnorePain			= mod:NewBuffActiveTimer(8, 2142343)


function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2142343) then
		warningIgnorePain:Show()
        timerIgnorePain:Start()
	end
end