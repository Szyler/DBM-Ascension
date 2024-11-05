local mod	= DBM:NewMod("Weaver", "DBM-Party-Vanilla", 17)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(5720)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

--TODO, Change timers to sourcename timers when not AI
local warnWingFlap						= mod:NewSpellAnnounce(12882, 2)
local warnAcidBreath					= mod:NewSpellAnnounce(12884, 2)

local timerWingFlapCD					= mod:NewCDTimer(180, 12882)
local timerAcidBreathCD					= mod:NewCDTimer(180, 12884)

function mod:OnCombatStart(delay)
	timerWingFlapCD:Start(1-delay)
	timerAcidBreathCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(12882) then
		warnWingFlap:Show()
		timerWingFlapCD:Start()
	elseif args:IsSpellID(12884) then
		warnAcidBreath:Show()
		timerAcidBreathCD:Start()
	end
end
