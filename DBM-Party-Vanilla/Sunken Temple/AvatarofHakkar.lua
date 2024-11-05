local mod	= DBM:NewMod(457, "DBM-Party-Vanilla", 17, 237)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(8443)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningCurseofTongues			= mod:NewTargetAnnounce(12889, 2, nil, "RemoveCurse")
local warningCauseInsanity			= mod:NewTargetAnnounce(12888, 4)

local timerCurseofTonguesCD			= mod:NewCDTimer(180, 12889)
local timerCauseInsanityCD			= mod:NewCDTimer(180, 12888)

function mod:OnCombatStart(delay)
	timerCurseofTonguesCD:Start(1-delay)
	timerCauseInsanityCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(12889) then
		timerCurseofTonguesCD:Start()
	elseif args:IsSpellID(12888) then
		timerCauseInsanityCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(12889) then
		warningCurseofTongues:Show(args.destName)
	elseif args:IsSpellID(12888) then
		warningCauseInsanity:Show(args.destName)
	end
end
