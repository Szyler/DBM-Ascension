local mod	= DBM:NewMod("Jergosh", "DBM-Party-Vanilla", 9)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(11518)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningCurseofWeakness			= mod:NewTargetAnnounce(18267, 2)
local warningImmolate					= mod:NewTargetAnnounce(20800, 2, nil, "Healer|RemoveMagic")

local timerCurseofWeaknessCD			= mod:NewCDTimer(180, 18267)
local timerImmolateCD					= mod:NewCDTimer(180, 20800)

function mod:OnCombatStart(delay)
	timerCurseofWeaknessCD:Start(1-delay)
	timerImmolateCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(18267) then
		timerCurseofWeaknessCD:Start()
	elseif args:IsSpellID(20800) then
		timerImmolateCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(18267) then
		warningCurseofWeakness:Show(args.destName)
	elseif args:IsSpellID(20800) then
		warningImmolate:Show(args.destName)
	end
end
