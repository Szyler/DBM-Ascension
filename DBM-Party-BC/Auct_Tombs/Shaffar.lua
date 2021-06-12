local mod	= DBM:NewMod("Shaffar", "DBM-Party-BC", 8)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))
mod:SetCreatureID(18344)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

local timerNextBlink   				= mod:NewNextTimer(20, 34605)
local warnNova 			 			= mod:NewSpellAnnounce(32365, 3)
local timerNextNova   				= mod:NewNextTimer(20, 32365)
local timerNextEthereal   			= mod:NewNextTimer(10, 32371)

function mod:OnCombatStart(delay)
	timerNextBlink:Start(15-delay)
	timerNextNova:Start(14-delay)
	timerNextEthereal:Start(-delay)
	self:ScheduleMethod(10-delay, "NewAdds")
	timerNextEthereal:Start(10-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 34605 then
		timerNextBlink:Start()
	elseif args.spellId == 32365 then
		warnNova:Show()
		timerNextNova:Start()
	end
end

function mod:NewAdds()
	timerNextEthereal:Start()
	self:ScheduleMethod(10, "NewAdds")
end

-- 34605 - Blink
-- 32365 - Frost Nova
-- 32371 - Summon Ethereal Becon