local mod	= DBM:NewMod("O'mrogg", "DBM-Party-BC", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))
mod:SetCreatureID(16809)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

local timerFear		        = mod:NewNextTimer(30, 30584)
local timerBlastWave		= mod:NewNextTimer(30, 30600)
local timerThunderClap		= mod:NewNextTimer(30, 30633)

function mod:OnCombatStart(delay)
	timerBlastWave:Start(27)
	timerFear:Start()
	timerThunderClap:Start(15)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 30584 then
		timerFear:Start()
	elseif args.spellId == 30600 then
		timerBlastWave:Start()
	elseif args.spellId == 30600 then
		timerThunderClap:Start()
	end
end

-- 30600 - Blast Wave
-- 30633 - Thunderclap
-- 30584 - Fear