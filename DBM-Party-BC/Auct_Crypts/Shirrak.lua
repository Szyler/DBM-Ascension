local mod	= DBM:NewMod("Shirrak", "DBM-Party-BC", 7)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))
mod:SetCreatureID(18371)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE"
)

local warnAttract		 		= mod:NewSpellAnnounce(32265, 3)
local timerNextAttract			= mod:NewNextTimer(30, 32265)
local warnBite					= mod:NewAnnounce(L.ShirrakBite, 2, 85178)

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 32265 then
		timerAcid:Start()
		wardAcid:Show(args.destName)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(39382) then
		warnBite:Show(args.spellName, args.destName, args.amount or 1)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(39382) then
		warnBite:Show(args.spellName, args.destName, args.amount or 1)
	end
end

-- 39382 - Carnivorous Bite
-- 32265 - Attract Magic