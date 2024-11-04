local mod	= DBM:NewMod("Bazzalan", "DBM-Party-Vanilla", 9)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(11519)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningDeadlyPoison			= mod:NewTargetNoFilterAnnounce(744, 2, nil, "RemovePoison")

local timerDeadlyPoisonCD			= mod:NewAITimer(180, 744, nil, "RemovePoison", nil, 5, nil, DBM_CORE_L.POISON_ICON)

function mod:OnCombatStart(delay)
	timerDeadlyPoisonCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(744) then
		timerDeadlyPoisonCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 744 and args:IsDestTypePlayer() and self:CheckDispelFilter() then
		warningDeadlyPoison:Show(args.destName)
	end
end
