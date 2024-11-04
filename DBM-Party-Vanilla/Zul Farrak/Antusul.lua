local mod	= DBM:NewMod(484, "DBM-Party-Vanilla", 20, 241)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(8127)
mod:SetEncounterID(595)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)

--TODO, Totems on shared timer?
--TODO, tone down special warnings if they are too much. They might be more than people are used to/want in classic
local warningEarthgrabTotem			= mod:NewSpellAnnounce(8376, 2)
local warningHealingWard			= mod:NewSpellAnnounce(4971, 4)

local specWarnHealingWaveSelf			= mod:NewSpecialWarningInterrupt(11895, "HasInterrupt", nil, nil, 1, 2)
local specWarnHealingWaveAlly			= mod:NewSpecialWarningInterrupt(15982, "HasInterrupt", nil, nil, 1, 2)
local specWarnMinions					= mod:NewSpecialWarningSwitch(11894, "Dps", nil, nil, 1, 2)

local timerHealingWaveSelfCD			= mod:NewAITimer(180, 11895, nil, nil, nil, 4, nil, DBM_CORE_L.INTERRUPT_ICON)
local timerHealingWaveAllyCD			= mod:NewAITimer(180, 15982, nil, nil, nil, 4, nil, DBM_CORE_L.INTERRUPT_ICON)
local timerMinionsCD					= mod:NewAITimer(180, 11894, nil, nil, nil, 1, nil, DBM_CORE_L.DAMAGE_ICON)

function mod:OnCombatStart(delay)
	timerHealingWaveSelfCD:Start(1-delay)
	timerHealingWaveAllyCD:Start(1-delay)
	timerMinionsCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(11895) then
		timerHealingWaveSelfCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHealingWaveSelf:Show(args.sourceName)
			specWarnHealingWaveSelf:Play("kickcast")
		end
	elseif args:IsSpellID(15982) then
		timerHealingWaveAllyCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHealingWaveAlly:Show(args.sourceName)
			specWarnHealingWaveAlly:Play("kickcast")
		end
	elseif args:IsSpellID(8376) then
		warningEarthgrabTotem:Show()
	elseif args:IsSpellID(4971) then
		warningHealingWard:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(11894) then
		specWarnMinions:Show()
		specWarnMinions:Play("killmob")
		timerMinionsCD:Start()
	end
end
