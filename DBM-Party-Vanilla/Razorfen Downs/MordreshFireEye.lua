local mod	= DBM:NewMod("MordreshFireEye", "DBM-Party-Vanilla", 10)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7357)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)

local warningFireNova			= mod:NewSpellAnnounce(12470, 2)

local specWarnFireball			= mod:NewInterruptAnnounce(12466)

local timerFireballCD			= mod:NewCDTimer(180, 12466)
local timerFireNovaCD			= mod:NewCDTimer(180, 12470)

function mod:OnCombatStart(delay)
	timerFireballCD:Start(1-delay)
	timerFireNovaCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(12466) then
		timerFireballCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnFireball:Show(args.sourceName)
			specWarnFireball:Play("kickcast")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(12470) then
		warningFireNova:Show()
		timerFireNovaCD:Start()
	end
end
