local mod	= DBM:NewMod("Bazzalan", "DBM-Party-Vanilla", 9)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(11519)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningDeadlyPoison			= mod:NewTargetAnnounce(744, 2, nil, "RemovePoison")

local timerDeadlyPoisonCD			= mod:NewCDTimer(180, 744)

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
