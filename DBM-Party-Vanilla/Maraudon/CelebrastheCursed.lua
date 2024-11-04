local mod	= DBM:NewMod(428, "DBM-Party-Vanilla", 8, 232)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(12225)
mod:SetEncounterID(425)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

--TODO, Add https://www.wowhead.com/spell=21793/twisted-tranquility using right event?
local warningEntanglingRoots		= mod:NewTargetNoFilterAnnounce(12747, 2)
local warningCorruptForces			= mod:NewSpellAnnounce(21968, 2, nil, false)

local specWarnWrath					= mod:NewSpecialWarningInterrupt(21807, "HasInterrupt", nil, nil, 1, 2)

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(21807) then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnWrath:Show(args.sourceName)
			specWarnWrath:Play("kickcast")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(21968) then
		warningCorruptForces:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(12747) then
		warningEntanglingRoots:Show(args.destName)
	end
end
