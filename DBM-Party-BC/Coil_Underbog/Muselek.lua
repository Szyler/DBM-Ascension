local mod	= DBM:NewMod("Muselek", "DBM-Party-BC", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))
mod:SetCreatureID(17826)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START"
)

local warnTrap		 		= mod:NewSpellAnnounce(31932, 3)
local timerTrap				= mod:NewBuffActiveTimer(5, 831623)
local timerAimed			= mod:NewTargetTimer(6, 831623)
local warnAimed		 		= mod:NewSpellAnnounce(31932, 3)
local warnMulti				= mod:NewTargetAnnounce(34974, 3)
local timerMulti			= mod:NewTargetTimer(1, 34974)
local timerKnock			= mod:NewNextTimer(8, 18813)


function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 31932 then
		warnTrap:Show()
		timerAimed:Start()
	elseif args.spellId == 31615 then
		warnAimed:Show()
		timerAimed:Start(args.destName)
	elseif args.spellId == 18813 then
		timerKnock:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 34974 then
		warnMulti:Show()
		timerMulti:Start()
	end
end

-- 31932 - Freezing Trap Effect
-- 31615 - Hunter's Mark
-- 831623 - Aimed Shot
-- 34974 - Multi-Shot
-- 18813 - Knock Away