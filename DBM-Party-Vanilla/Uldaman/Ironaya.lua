local mod	= DBM:NewMod(469, "DBM-Party-Vanilla", 18, 239)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7228)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

local warningArcingSmash			= mod:NewSpellAnnounce(8374, 2)
local warningWarStomp				= mod:NewSpellAnnounce(11876, 2)

local timerArcingSmashCD			= mod:NewCDTimer(180, 8374)
local timerWarStompCD				= mod:NewCDTimer(180, 11876)

function mod:OnCombatStart(delay)
	timerArcingSmashCD:Start(1-delay)
	timerWarStompCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(8374) then
		warningArcingSmash:Show()
		timerArcingSmashCD:Start()
	elseif args:IsSpellID(11876) then
		warningWarStomp:Show()
		timerWarStompCD:Start()
	end
end
