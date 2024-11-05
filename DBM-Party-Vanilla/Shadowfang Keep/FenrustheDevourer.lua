local mod	= DBM:NewMod("FenrustheDevourer", "DBM-Party-Vanilla", 14)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(4274)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningToxicSaliva				= mod:NewTargetAnnounce(7125, 2, nil, "RemovePoison")

local timerToxicSalivaCD				= mod:NewCDTimer(180, 7125)

function mod:OnCombatStart(delay)
	timerToxicSalivaCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(7125) then
		timerToxicSalivaCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 7125 and self:CheckDispelFilter() then
		warningToxicSaliva:Show(args.destName)
	end
end
