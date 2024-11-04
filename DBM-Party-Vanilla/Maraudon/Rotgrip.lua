local mod	= DBM:NewMod(430, "DBM-Party-Vanilla", 8, 232)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(13596)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

--Puncture too random, and not important enough, so removed. Fatal bite was never seen?
local warningFatalBite				= mod:NewSpellAnnounce(16495, 3)

local timerFatalBiteCD				= mod:NewAITimer(180, 16495, nil, nil, nil, 5, nil, DBM_CORE_L.TANK_ICON)

function mod:OnCombatStart(delay)
	timerFatalBiteCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(15976) then
		warningFatalBite:Show()
		timerFatalBiteCD:Start()
	end
end
