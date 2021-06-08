local mod	= DBM:NewMod("Porung", "DBM-Party-BC", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))
mod:SetCreatureID(20923)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

local warnFear		 		= mod:NewSpellAnnounce(29544, 3)
local timerFear				= mod:NewNextTimer(29, 29544)

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 29544 then
		warnFear:Show()
		timerFear:Start()
	end
end

--  29544 - Frightening Shout