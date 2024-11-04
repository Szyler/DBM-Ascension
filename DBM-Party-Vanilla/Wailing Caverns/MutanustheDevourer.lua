local mod	= DBM:NewMod(481, "DBM-Party-Vanilla", 19, 240)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(3654)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningNaralexsNightmare		= mod:NewTargetNoFilterAnnounce(7967, 2)
local warningTerrify				= mod:NewTargetNoFilterAnnounce(7399, 2)

local specWarnNaralexsNightmare		= mod:NewSpecialWarningInterrupt(7967, "HasInterrupt", nil, nil, 1, 2)

local timerNaralexsNightmareCD		= mod:NewAITimer(180, 7967, nil, nil, nil, 4, nil, DBM_CORE_L.INTERRUPT_ICON..DBM_CORE_L.MAGIC_ICON)
local timerTerrifyCD				= mod:NewAITimer(180, 7399, nil, nil, nil, 3, nil, DBM_CORE_L.MAGIC_ICON)
local timerThundercrackCD			= mod:NewAITimer(180, 8150, nil, nil, nil, 2, nil, DBM_CORE_L.HEALER_ICON..DBM_CORE_L.MAGIC_ICON)

function mod:OnCombatStart(delay)
	timerNaralexsNightmareCD:Start(1-delay)
	timerTerrifyCD:Start(1-delay)
	timerThundercrackCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(7967) then
		timerNaralexsNightmareCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnNaralexsNightmare:Show(args.sourceName)
			specWarnNaralexsNightmare:Play("kickcast")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(7399) then
		timerTerrifyCD:Start()
	elseif args:IsSpellID(8150) then
		timerThundercrackCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellName == Terrify then
		warningTerrify:Show(args.destName)
	end
end
