local mod	= DBM:NewMod("Ragglesnout", "DBM-Party-Vanilla", 10)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7354)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED"
)

local warningDominateMind			= mod:NewTargetNoFilterAnnounce(7645, 2)

local specWarnHeal					= mod:NewSpecialWarningInterrupt(12039, "HasInterrupt", nil, nil, 1, 2)

local timerHealCD					= mod:NewAITimer(180, 12039, nil, nil, nil, 4, nil, DBM_CORE_L.INTERRUPT_ICON)
local timerDominateMindCD			= mod:NewAITimer(180, 7645, nil, nil, nil, 3)

function mod:OnCombatStart(delay)
	timerHealCD:Start(1-delay)
	timerDominateMindCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(12039) then
		timerHealCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHeal:Show(args.sourceName)
			specWarnHeal:Play("kickcast")
		end
	elseif args:IsSpellID(7645) then
		timerDominateMindCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(7645) then
		warningDominateMind:Show(args.destName)
	end
end
