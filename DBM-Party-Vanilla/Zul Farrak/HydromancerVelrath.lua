local mod	= DBM:NewMod("HydromancerVelrath", "DBM-Party-Vanilla", 20)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7795)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START"
)

local specWarnHealingWave			= mod:NewInterruptAnnounce(12491)

local timerHealingWaveCD			= mod:NewCDTimer(180, 12491)

function mod:OnCombatStart(delay)
	timerHealingWaveCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(12491) then
		timerHealingWaveCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHealingWave:Show(args.sourceName)
			specWarnHealingWave:Play("kickcast")
		end
	end
end
