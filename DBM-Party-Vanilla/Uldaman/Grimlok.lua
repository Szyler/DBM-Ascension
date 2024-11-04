local mod	= DBM:NewMod(472, "DBM-Party-Vanilla", 18, 239)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(4854)
mod:SetEncounterID(553)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningBloodlust				= mod:NewTargetNoFilterAnnounce(6742, 3)
local warningReflection				= mod:NewTargetNoFilterAnnounce(9906, 4)
local warningCrystallineSlumber		= mod:NewTargetNoFilterAnnounce(3636, 4, nil, "RemoveMagic")

local specWarnChainBolt				= mod:NewSpecialWarningInterrupt(8292, "HasInterrupt", nil, nil, 1, 2)
local specWarnLightningBolt			= mod:NewSpecialWarningInterrupt(12167, false, nil, nil, 1, 2)

local timerChainBoltCD				= mod:NewAITimer(180, 8292, nil, nil, nil, 4, nil, DBM_CORE_L.INTERRUPT_ICON)
local timerLightningBoltCD			= mod:NewAITimer(180, 12167, nil, nil, nil, 4, nil, DBM_CORE_L.INTERRUPT_ICON)
local timerBloodlustCD				= mod:NewAITimer(180, 6742, nil, nil, nil, 5, nil, DBM_CORE_L.MAGIC_ICON)

function mod:OnCombatStart(delay)
	timerChainBoltCD:Start(1-delay)
	timerLightningBoltCD:Start(1-delay)
	timerBloodlustCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(8292) then
		timerChainBoltCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnChainBolt:Show(args.sourceName)
			specWarnChainBolt:Play("kickcast")
		end
	elseif args:IsSpellID(12167) then
		timerLightningBoltCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnLightningBolt:Show(args.sourceName)
			specWarnLightningBolt:Play("kickcast")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
		if args:IsSpellID(6742) then
			timerBloodlustCD:Start()
		end
	end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(6742) then
		warningBloodlust:Show(args.destName)
	elseif args:IsSpellID(9906) then
		warningReflection:Show(args.destName)
	elseif args:IsSpellID(3636) then
		warningCrystallineSlumber:Show(args.destName)
	end
end
