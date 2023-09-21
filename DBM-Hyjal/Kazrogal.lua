local mod	= DBM:NewMod("Kazrogal", "DBM-Hyjal", 1)

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(17888, 117888, 217888, 317888)
mod:RegisterCombat("combat")

local timerNextPillar		= mod:NewTimer(55, "Pillar", 92177)
local timerNextWarstomp		= mod:NewNextTimer(55, 2141009)

function mod:Pillar()
	self:UnscheduleMethod("Pillar")
	timerNextPillar:Start()
	self:ScheduleMethod(55, "Pillar")
end

function mod:Warstomp()
	self:UnscheduleMethod("Warstomp")
	timerNextWarstomp:Start()
	self:ScheduleMethod(55, "Warstomp")
end

function mod:OnCombatStart(delay)
	timerNextPillar:Start(10 - delay)
	timerNextWarstomp:Start(-delay)
	self:ScheduleMethod(10 - delay, "Pillar")
	self:ScheduleMethod(55 - delay, "Warstomp")
end
