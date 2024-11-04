local mod	= DBM:NewMod(486, "DBM-Party-Vanilla", 20, 241)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7271)
mod:SetEncounterID(597)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)

local warningWardZumrah				= mod:NewSpellAnnounce(11086, 2)

local specWarnHealingWave			= mod:NewSpecialWarningInterrupt(12491, "HasInterrupt", nil, nil, 1, 2)
local specWarnShadowBoltVolley		= mod:NewSpecialWarningInterrupt(15245, "HasInterrupt", nil, nil, 1, 2)

local timerWardZumrahCD				= mod:NewAITimer(180, 11086, nil, nil, nil, 1, nil, DBM_CORE_L.DAMAGE_ICON)
local timerHealingWaveCD			= mod:NewAITimer(180, 12491, nil, nil, nil, 4, nil, DBM_CORE_L.INTERRUPT_ICON)
local timerShadowBoltVolleyCD		= mod:NewAITimer(180, 15245, nil, nil, nil, 4, nil, DBM_CORE_L.INTERRUPT_ICON)

function mod:OnCombatStart(delay)
	timerWardZumrahCD:Start(1-delay)
	timerHealingWaveCD:Start(1-delay)
	timerShadowBoltVolleyCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(12491) then
		timerHealingWaveCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHealingWave:Show(args.sourceName)
			specWarnHealingWave:Play("kickcast")
		end
	elseif args:IsSpellID(15245) then
		timerShadowBoltVolleyCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnShadowBoltVolley:Show(args.sourceName)
			specWarnShadowBoltVolley:Play("kickcast")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(11086) then
		warningWardZumrah:Show()
		timerWardZumrahCD:Start()
	end
end
