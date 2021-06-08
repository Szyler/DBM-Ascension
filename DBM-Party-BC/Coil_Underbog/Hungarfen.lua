local mod	= DBM:NewMod("Hungarfen", "DBM-Party-BC", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))
mod:SetCreatureID(17770)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warnFoulSpores  	= mod:NewSpellAnnounce(31673)
local timerAcid		 	= mod:NewNextTimer(15, 38739)
local wardAcid			= mod:NewSpellAnnounce(38739, 3)

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 38739 then
		timerAcid:Start()
		wardAcid:Show(args.destName)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 31673 then
		warnFoulSpores:Show()
	end
end