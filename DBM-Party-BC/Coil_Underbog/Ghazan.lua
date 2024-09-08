local mod	= DBM:NewMod("Ghazan", "DBM-Party-BC", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))
mod:SetCreatureID(18105)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

local timerAcidBreath		 	= mod:NewNextTimer(10, 38739)
local timerAcidSpit		 		= mod:NewNextTimer(10, 834290)
local timerTailSweep		 	= mod:NewCDTimer(9, 38737)

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 834268 then
		timerAcidBreath:Start()
	elseif args.spellId == 834290 then
		timerAcidSpit:Start()
	elseif args.spellId == 38737 then
		timerTailSweep:Start()
	end
end

-- 834268 - Acid Breath
-- 834290 - Acid Spit
-- 38737 - Tail Sweep