local mod	= DBM:NewMod("DeviateFaerie", "DBM-Party-Vanilla", 19)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(5912)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED"
)

local warningDruidSlumber			= mod:NewTargetNoFilterAnnounce(8040, 2)

local specWarnDruidsSlumber			= mod:NewSpecialWarningInterrupt(8040, "HasInterrupt", nil, nil, 1, 2)

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(8040) then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnDruidsSlumber:Show(args.sourceName)
			specWarnDruidsSlumber:Play("kickcast")
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(8040) then
		warningDruidSlumber:Show(args.destName)
	end
end
