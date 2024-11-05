local mod	= DBM:NewMod("CharlgaRazorflank", "DBM-Party-Vanilla", 11)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(4421)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningPurity				= mod:NewTargetAnnounce(8361, 2)
local warningManaSpike			= mod:NewSpellAnnounce(8358, 2)

local specWarnChainBolt			= mod:NewInterruptAnnounce(8292)

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(8292) then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnChainBolt:Show(args.sourceName)
			specWarnChainBolt:Play("kickcast")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(8358) then
		warningManaSpike:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(8361) then
		warningPurity:Show(args.destName)
	end
end
